import Rails from '@rails/ujs';
import * as ActiveStorage from '@rails/activestorage';
import 'channels';
Rails.start();
ActiveStorage.start();

import 'bootstrap';
import 'controllers';
import './pagy.js.erb';
import Dropzone from 'dropzone';
require('dotenv').config();
require('./flickity-fullscreen.js');
require('./flickity-imagesloaded.js');

var Flickity = require('flickity');
var clamp = require('clamp-js');
var bodyScrollLock = require('body-scroll-lock');
var enableBodyScroll = bodyScrollLock.enableBodyScroll;
var disableBodyScroll = bodyScrollLock.disableBodyScroll;

window.Rails = Rails;
window.Flickity = Flickity;
window.clamp = clamp;
window.Dropzone = Dropzone;
window.enableBodyScroll = enableBodyScroll;
window.disableBodyScroll = disableBodyScroll;

Flickity.prototype._touchActionValue = 'pan-y pinch-zoom';
