/**
 * CM Analytics Tracker - Production
 * Editorial analytics tracking script for Jornal Correio da Manhã
 * 
 * Installation:
 * <script src="https://cm-analytics.onrender.com/tracker/tracker.js" data-site-id="correio-da-manha" async></script>
 * 
 * Future:
 * <script src="https://analytics.correiodamanha.com.br/tracker/tracker.js" data-site-id="correio-da-manha" async></script>
 */

(function(window, document) {
  'use strict';
  
  // Get the base URL from the current script source
  var scriptElement = document.currentScript || (function() {
    var scripts = document.getElementsByTagName('script');
    return scripts[scripts.length - 1];
  })();
  
  var trackerUrl = scriptElement.src;
  var baseUrl = trackerUrl.replace(/\/tracker\/tracker\.js$/, '');
  
  // Configuration
  var CONFIG = {
    apiEndpoint: baseUrl + '/api/v1/analytics/events',
    batchEndpoint: baseUrl + '/api/v1/analytics/batch',
    siteId: scriptElement.getAttribute('data-site-id') || 'correio-da-manha',
    batchSize: 10,
    batchTimeout: 5000, // 5 seconds
    debug: scriptElement.getAttribute('data-debug') === 'true'
  };
  
  // Event queue
  var eventQueue = [];
  var batchTimer = null;
  var sessionId = null;
  var pageLoadTime = Date.now();
  
  // Get or generate session ID
  function getSessionId() {
    if (sessionId) return sessionId;
    
    var stored = localStorage.getItem('cm_analytics_session');
    if (stored) {
      sessionId = stored;
    } else {
      sessionId = generateUUID();
      localStorage.setItem('cm_analytics_session', sessionId);
    }
    return sessionId;
  }
  
  // Generate UUID v4
  function generateUUID() {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
      var r = Math.random() * 16 | 0;
      var v = c === 'x' ? r : (r & 0x3 | 0x8);
      return v.toString(16);
    });
  }
  
  // Extract metadata from page
  function extractMetadata() {
    var meta = {};
    
    // Standard meta tags
    var metaTags = {
      'article:author': 'author',
      'article:section': 'section',
      'article:published_time': 'published_at',
      'og:title': 'title',
      'og:image': 'image',
      'mrf:authors': 'author',
      'mrf:sections': 'section'
    };
    
    for (var property in metaTags) {
      var element = document.querySelector('meta[property="' + property + '"]') ||
                     document.querySelector('meta[name="' + property + '"]');
      if (element) {
        meta[metaTags[property]] = element.getAttribute('content');
      }
    }
    
    // Try JSON-LD structured data
    var scripts = document.querySelectorAll('script[type="application/ld+json"]');
    for (var i = 0; i < scripts.length; i++) {
      try {
        var data = JSON.parse(scripts[i].textContent);
        if (data['@type'] === 'NewsArticle') {
          meta.title = meta.title || data.headline;
          meta.author = meta.author || (data.author && data.author.name);
          meta.image = meta.image || data.image;
          meta.published_at = meta.published_at || data.datePublished;
        }
      } catch (e) {
        // Ignore JSON parse errors
      }
    }
    
    return meta;
  }
  
  // Get device information
  function getDeviceInfo() {
    var ua = navigator.userAgent;
    
    return {
      device_type: getDeviceType(ua),
      browser: getBrowser(ua),
      os: getOS(ua),
      screen_width: window.screen.width,
      screen_height: window.screen.height,
      viewport_width: window.innerWidth,
      viewport_height: window.innerHeight
    };
  }
  
  function getDeviceType(ua) {
    if (/tablet|ipad|playbook|silk/i.test(ua)) return 'tablet';
    if (/mobile|android|iphone|ipod/i.test(ua)) return 'mobile';
    return 'desktop';
  }
  
  function getBrowser(ua) {
    if (/chrome/i.test(ua) && !/edge|opr|brave/i.test(ua)) return 'Chrome';
    if (/safari/i.test(ua) && !/chrome/i.test(ua)) return 'Safari';
    if (/firefox/i.test(ua)) return 'Firefox';
    if (/edge/i.test(ua)) return 'Edge';
    if (/opr/i.test(ua)) return 'Opera';
    if (/brave/i.test(ua)) return 'Brave';
    return 'Unknown';
  }
  
  function getOS(ua) {
    if (/windows/i.test(ua)) return 'Windows';
    if (/macintosh|mac os x/i.test(ua)) return 'macOS';
    if (/android/i.test(ua)) return 'Android';
    if (/iphone|ipad|ipod/i.test(ua)) return 'iOS';
    if (/linux/i.test(ua)) return 'Linux';
    return 'Unknown';
  }
  
  // Build event payload
  function buildEvent(eventName, additionalData) {
    additionalData = additionalData || {};
    var metadata = extractMetadata();
    var device = getDeviceInfo();
    
    return {
      site_id: CONFIG.siteId,
      event: eventName,
      url: window.location.href,
      referrer: document.referrer || 'direct',
      session_id: getSessionId(),
      article_id: extractArticleId(),
      title: metadata.title || document.title,
      author: metadata.author,
      section: metadata.section,
      position: additionalData.position,
      device_type: device.device_type,
      browser: device.browser,
      os: device.os,
      scroll_depth: additionalData.scroll_depth,
      time_on_page: additionalData.time_on_page,
      metadata: {
        screen_width: device.screen_width,
        screen_height: device.screen_height,
        viewport_width: device.viewport_width,
        viewport_height: device.viewport_height,
        published_at: metadata.published_at,
        image: metadata.image
      }
    };
  }
  
  // Extract article ID from URL or meta tags
  function extractArticleId() {
    // Try meta tag first
    var metaArticleId = document.querySelector('meta[name="article:id"]');
    if (metaArticleId) {
      return parseInt(metaArticleId.getAttribute('content'));
    }
    
    // Try URL pattern (adjust based on your URL structure)
    // Example: /news/12345-article-title
    var urlMatch = window.location.pathname.match(/\/(\d+)-/);
    if (urlMatch) {
      return parseInt(urlMatch[1]);
    }
    
    // Try data attribute on article element
    var article = document.querySelector('article[data-article-id]');
    if (article) {
      return parseInt(article.getAttribute('data-article-id'));
    }
    
    return null;
  }
  
  // Send event to server using sendBeacon
  function sendEvent(event) {
    if (CONFIG.debug) {
      console.log('CM Analytics Event:', event);
    }
    
    eventQueue.push(event);
    
    if (eventQueue.length >= CONFIG.batchSize) {
      flushEvents();
    } else {
      scheduleBatch();
    }
  }
  
  // Schedule batch send
  function scheduleBatch() {
    if (batchTimer) clearTimeout(batchTimer);
    batchTimer = setTimeout(flushEvents, CONFIG.batchTimeout);
  }
  
  // Flush event queue
  function flushEvents() {
    if (eventQueue.length === 0) return;
    
    var events = eventQueue.slice();
    eventQueue = [];
    
    if (batchTimer) {
      clearTimeout(batchTimer);
      batchTimer = null;
    }
    
    // Use batch endpoint for multiple events
    if (events.length > 1) {
      sendBatch(events);
    } else {
      sendSingle(events[0]);
    }
  }
  
  function sendSingle(event) {
    var payload = JSON.stringify(event);
    var endpoint = CONFIG.apiEndpoint;
    
    if (navigator.sendBeacon) {
      var blob = new Blob([payload], { type: 'application/json' });
      try {
        navigator.sendBeacon(endpoint, blob);
        return;
      } catch (e) {
        if (CONFIG.debug) console.error('sendBeacon failed:', e);
      }
    }
    
    // Fallback to fetch
    fetch(endpoint, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: payload,
      keepalive: true
    }).catch(function(err) {
      if (CONFIG.debug) console.error('Failed to send event:', err);
    });
  }
  
  function sendBatch(events) {
    var payload = JSON.stringify({ events: events });
    var endpoint = CONFIG.batchEndpoint;
    
    if (navigator.sendBeacon) {
      var blob = new Blob([payload], { type: 'application/json' });
      try {
        navigator.sendBeacon(endpoint, blob);
        return;
      } catch (e) {
        if (CONFIG.debug) console.error('sendBeacon failed:', e);
      }
    }
    
    // Fallback to fetch
    fetch(endpoint, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: payload,
      keepalive: true
    }).catch(function(err) {
      if (CONFIG.debug) console.error('Failed to send batch:', err);
    });
  }
  
  // Public API
  window.CMAnalytics = {
    // Track page view
    trackPageView: function() {
      sendEvent(buildEvent('page_view'));
    },
    
    // Track article click
    trackClick: function(position) {
      sendEvent(buildEvent('article_click', { position: position }));
    },
    
    // Track scroll depth
    trackScroll: function(depth) {
      sendEvent(buildEvent('scroll_depth', { scroll_depth: depth }));
    },
    
    // Track time on page
    trackTimeOnPage: function(seconds) {
      sendEvent(buildEvent('time_on_page', { time_on_page: seconds }));
    },
    
    // Custom event tracking
    track: function(eventName, data) {
      data = data || {};
      sendEvent(buildEvent(eventName, data));
    },
    
    // Manual flush
    flush: function() {
      flushEvents();
    }
  };
  
  // Initialize tracking
  function init() {
    // Track initial page view
    if (document.readyState === 'complete') {
      window.CMAnalytics.trackPageView();
    } else {
      window.addEventListener('load', function() {
        window.CMAnalytics.trackPageView();
      });
    }
    
    // Track scroll depth
    setupScrollTracking();
    
    // Track article clicks
    setupClickTracking();
    
    // Track time on page
    setupTimeTracking();
    
    // Flush events on page unload
    window.addEventListener('beforeunload', function() {
      window.CMAnalytics.flush();
    });
    
    // Handle visibility change
    document.addEventListener('visibilitychange', function() {
      if (document.hidden) {
        window.CMAnalytics.flush();
      }
    });
  }
  
  // Scroll depth tracking
  function setupScrollTracking() {
    var thresholds = [25, 50, 75, 90, 100];
    var tracked = {};
    
    window.addEventListener('scroll', function() {
      var scrollPercent = Math.round(
        (window.scrollY / (document.documentElement.scrollHeight - window.innerHeight)) * 100
      );
      
      for (var i = 0; i < thresholds.length; i++) {
        var threshold = thresholds[i];
        if (scrollPercent >= threshold && !tracked[threshold]) {
          tracked[threshold] = true;
          window.CMAnalytics.trackScroll(threshold);
        }
      }
    }, { passive: true });
  }
  
  // Click tracking for article links
  function setupClickTracking() {
    document.addEventListener('click', function(e) {
      var link = e.target.closest('a[href*="/"], article[data-article-id]');
      if (!link) return;
      
      // Determine position
      var position = 'unknown';
      var parent = link.closest('section, .hero, .featured, .list-item');
      if (parent) {
        position = parent.className || parent.id || 'unknown';
      }
      
      // Small delay to allow navigation
      setTimeout(function() {
        window.CMAnalytics.trackClick(position);
      }, 10);
    }, true);
  }
  
  // Time on page tracking
  function setupTimeTracking() {
    var intervals = [30, 60, 120, 300, 600]; // 30s, 1m, 2m, 5m, 10m
    var tracked = {};
    
    for (var i = 0; i < intervals.length; i++) {
      (function(seconds) {
        setTimeout(function() {
          if (!tracked[seconds] && !document.hidden) {
            tracked[seconds] = true;
            window.CMAnalytics.trackTimeOnPage(seconds);
          }
        }, seconds * 1000);
      })(intervals[i]);
    }
  }
  
  // Start initialization
  init();
  
})(window, document);
