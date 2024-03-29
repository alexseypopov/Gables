/*!
 * VERSION: beta 0.1.2
 * DATE: 2013-06-05
 * UPDATES AND DOCS AT: http://www.greensock.com
 *
 * @license Copyright (c) 2008-2013, GreenSock. All rights reserved.
 * SplitText is a Club GreenSock membership benefit; You must have a valid membership to use
 * this code without violating the terms of use. Visit http://www.greensock.com/club/ to sign up or get more details.
 * This work is subject to the software agreement that was issued with your membership.
 * 
 * @author: Jack Doyle, jack@greensock.com
 */
(function(window) {
	
	"use strict";
	var _globals = window.GreenSockGlobals || window,
		_namespace = function(ns) {
			var a = ns.split("."),
				p = _globals, i;
			for (i = 0; i < a.length; i++) {
				p[a[i]] = p = p[a[i]] || {};
			}
			return p;
		},
		pkg = _namespace("com.greensock.text"),
		_getText = function(e) {
			var type = e.nodeType,
				result = "";
			if (type === 1 || type === 9 || type === 11) {
				if (typeof(e.textContent) === "string") {
					return e.textContent;
				} else {
					for ( e = e.firstChild; e; e = e.nextSibling ) {
						result += _getText(e);
					}
				}
			} else if (type === 3 || type === 4) {
				return e.nodeValue;
			}
			return result;
		},
		_doc = document,
		_getComputedStyle = _doc.defaultView ? _doc.defaultView.getComputedStyle : function() {},
		_capsExp = /([A-Z])/g,
		_getStyle = function(t, p, cs, str) {
			var result;
			if ((cs = cs || _getComputedStyle(t, null))) {
				t = cs.getPropertyValue(p.replace(_capsExp, "-$1").toLowerCase());
				result = (t || cs.length) ? t : cs[p]; //Opera behaves VERY strangely - length is usually 0 and cs[p] is the only way to get accurate results EXCEPT when checking for -o-transform which only works with cs.getPropertyValue()!
			} else if (t.currentStyle) {
				cs = t.currentStyle;
				result = cs[p];
			}
			return str ? result : parseInt(result, 10) || 0;
		},
		_isArrayLike = function(e) {
			return (e.length && e[0] && e[0].nodeType && e[0].style && !e.nodeType) ? true : false;
		},
		_brSwap = ")eefec303079ad17405c",
		_brExp = /(?:<br>|<br\/>|<br \/>)/gi,
		_isOldIE = (_doc.all && !_doc.addEventListener),
		_divStart = "<div style='position:relative;display:inline-block;" + (_isOldIE ? "*display:inline;*zoom:1;'" : "'"),//note: we must use both display:inline-block and *display:inline for IE8 and earlier, otherwise it won't flow correctly (and if we only use display:inline, IE won't render most of the property tweens - very odd).
		_cssClassFunc = function(cssClass) {
			cssClass = cssClass || "";
			var iterate = (cssClass.indexOf("++") !== -1),
				num = 1;
			if (iterate) {
				cssClass = cssClass.split("++").join("");
			}
			return function() {
				return _divStart + (cssClass ? " class='" + cssClass + (iterate ? num++ : "") + "'>" : ">");
			};
		},
		SplitText = pkg.SplitText = _globals.SplitText = function(element, config) {
			if (typeof(element) === "string") {
				element = SplitText.selector(element);
			}
			if (!element) {
				throw("cannot split a null element.");
			}
			this.elements = _isArrayLike(element) ? element : [element];
			this.chars = [];
			this.words = [];
			this.lines = [];
			this._originals = [];
			this.config = config || {};
			this.split(config);
		},
		_split = function(element, config, allChars, allWords, allLines) {
			if (_brExp.test(element.innerHTML)) {
				element.innerHTML = element.innerHTML.replace(_brExp, _brSwap); //swap in a unique string for <br/> tags so that we can identify it when we loop through later, and replace it appropriately
			}
			var text = _getText(element),
				types = config.split || "chars,words,lines",
				lines = (types.indexOf("lines") !== -1) ? [] : null,
				words = (types.indexOf("words") !== -1),
				chars = (types.indexOf("chars") !== -1),
				absolute = config.absolute,
				space = absolute ? "&#173; " : " ",
				lineOffsetY = -999,
				cs = _getComputedStyle(element),
				paddingLeft = _getStyle(element, "paddingLeft", cs, true),
				borderTopAndBottom = _getStyle(element, "borderBottomWidth", cs) + _getStyle(element, "borderTopWidth", cs),
				padTopAndBottom = _getStyle(element, "paddingTop", cs) + _getStyle(element, "paddingBottom", cs),
				textAlign = _getStyle(element, "textAlign", cs, true),
				origHeight = element.clientHeight,
				l = text.length,
				wordEnd = "</div>",
				wordStart = _cssClassFunc(config.wordsClass),
				charStart = _cssClassFunc(config.charsClass),
				iterateLine = ((config.linesClass || "").indexOf("++") !== -1),
				linesClass = config.linesClass,
				curLine, isChild, splitText, i, j, character, nodes, node, offset, lineNode, style, lineWidth;

			if (iterateLine) {
				linesClass = linesClass.split("++").join("");
			}

			splitText = wordStart();

			for (i = 0; i < l; i++) {
				character = text.charAt(i);
				if (character === ")" && text.substr(i, 20) === _brSwap) {
					splitText += wordEnd + "<BR/>";
					if (i !== l - 1) {
						splitText += " " + wordStart();
					}
					i += _isOldIE ? 19 : 20;

				} else if (character === " " && text.charAt(i-1) !== " " && i !== l-1) {
					splitText += wordEnd;
					if (i !== l - 1) {
						splitText += space + wordStart();
					}
				} else {
					splitText += (chars && character !== " ") ? charStart() + character + "</div>" : character;
				}
			}
			element.innerHTML = splitText + wordEnd;

			//copy all the descendant nodes into an array (we can't use a regular nodeList because it's live and we may need to renest things)
			j = element.getElementsByTagName("*");
			l = j.length;
			nodes = [];
			for (i = 0; i < l; i++) {
				nodes[i] = j[i];
			}

			//for absolute positioning, we need to record the x/y offsets and width/height for every <div>. And even if we're not positioning things absolutely, in order to accommodate lines, we must figure out where the y offset changes so that we can sense where the lines break, and we populate the lines array.
			if (lines || absolute) {
				for (i = 0; i < l; i++) {
					node = nodes[i];
					isChild = (node.parentNode === element);
					if (isChild || absolute || (chars && !words)) {
					 	offset = node.offsetTop;
						if (lines && isChild && offset !== lineOffsetY && node.nodeName !== "BR") {
							curLine = [];
							lines.push(curLine);
							lineOffsetY = offset;
						}
						if (absolute) { //record offset x and y, as well as width and height so that we can access them later for positioning. Grabbing them at once ensures we don't trigger a browser paint & we maximize performance.
							node._x = node.offsetLeft;
							node._y = offset;
							node._w = node.offsetWidth;
							node._h = node.offsetHeight;
						}
						if (lines) {
							if (words === isChild || !chars) {
								curLine.push(node);
								node._x -= parseFloat(paddingLeft);
							}
							if (isChild && i) {
								nodes[i-1]._wordEnd = true;
							}
						}
					}
				}
			}

			for (i = 0; i < l; i++) {
				node = nodes[i];
				isChild = (node.parentNode === element);
				if (node.nodeName === "BR") {
					if (lines || absolute) {
						element.removeChild(node);
						nodes.splice(i--, 1);
						l--;
					} else if (!words) {
						element.appendChild(node);
					}
					continue;
				}

				if (absolute) {
					style = node.style;
					if (!words && !isChild) {
						node._x += node.parentNode._x;
						node._y += node.parentNode._y;
					}
					style.left = node._x + "px";
					style.top = node._y + "px";
					style.position = "absolute";
					style.display = "block";
					//if we don't set the width/height, things collapse in older versions of IE and the origin for transforms is thrown off in all browsers.
					style.width = node._w + "px";
					style.height = node._h + "px";
				}

				if (!words) {
					//we always start out wrapping words in their own <div> so that line breaks happen correctly, but here we'll remove those <div> tags if necessary and renest the characters directly into the element rather than inside the word <div>
					if (isChild) {
						element.removeChild(node);
						nodes.splice(i--, 1);
						l--;
					} else if (!isChild && chars) {
						element.appendChild(node);
						allChars.push(node);
					}
				} else if (isChild) {
					allWords.push(node);
				} else if (chars) {
					allChars.push(node);
				}
			}


			if (lines) {

				//the next 6 lines just give us the line width in the most reliable way. We must set it along with text-align to ensure everything works properly for various alignments.
				if (absolute) {
					lineNode = _doc.createElement("div");
					element.appendChild(lineNode);
					lineWidth = lineNode.offsetWidth + "px";
					element.removeChild(lineNode);
				}

				style = element.style.cssText;
				element.style.cssText = "display:none;"; //to improve performance, set display:none on the element so that the browser doesn't have to worry about reflowing or rendering while we're renesting things. We'll revert the cssText later.
				for (i = 0; i < lines.length; i++) {
					curLine = lines[i];
					lineNode = _doc.createElement("div");
					lineNode.style.cssText = "display:block;text-align:" + textAlign + ";position:" + (absolute ? "absolute;" : "relative;");
					if (linesClass) {
						lineNode.className = linesClass + (iterateLine ? i+1 : "");
					}
					allLines.push(lineNode);
					l = curLine.length;
					for (j = 0; j < l; j++) {
						if (curLine[j].nodeName !== "BR") {
							node = curLine[j];
							lineNode.appendChild(node);
							if (node._wordEnd) {
								lineNode.appendChild(_doc.createTextNode(" "));
							}
							if (absolute) {
								if (j === 0) {
									lineNode.style.top = node._y + "px";
									lineNode.style.left = paddingLeft;
								}
								node.style.top = "0px";
							}
						}
					}
					if (!words && !chars) {
						lineNode.innerHTML = _getText(lineNode).split(String.fromCharCode(160)).join(" ");
					}
					if (absolute) {
						lineNode.style.width = lineWidth;
						lineNode.style.height = node._h + "px";
					}
					element.appendChild(lineNode);
				}
				element.style.cssText = style;
			}

			if (origHeight > element.clientHeight) { //if everything shifts to being position:absolute, the container can collapse in terms of height, so fix that here.
				element.style.height = (origHeight - padTopAndBottom) + "px";
				if (element.clientHeight < origHeight) { //IE8 and earlier use a different box model - we must include padding and borders
					element.style.height = (origHeight + borderTopAndBottom)+ "px";
				}
			}

		},
		p = SplitText.prototype;

	p.split = function(config) {
		if (this.isSplit) {
			this.revert();
		}
		this.config = config || this.config;
		this._originals.length = this.chars.length = this.words.length = this.lines.length = 0;
		for (var i = 0; i < this.elements.length; i++) {
			this._originals[i] = this.elements[i].innerHTML;
			_split(this.elements[i], this.config, this.chars, this.words, this.lines);
		}
		this.isSplit = true;
		return this;
	};

	p.revert = function() {
		if (!this._originals) {
			throw("revert() call wasn't scoped properly.");
		}
		var i = this._originals.length;
		while (--i > -1) {
			this.elements[i].innerHTML = this._originals[i];
		}
		this.chars = [];
		this.words = [];
		this.lines = [];
		this.isSplit = false;
		return this;
	};

	SplitText.selector = window.$ || window.jQuery || function(e) { if (window.$) { SplitText.selector = window.$; return window.$(e); } return _doc ? _doc.getElementById((e.charAt(0) === "#") ? e.substr(1) : e) : e; };
	
})(window || {});