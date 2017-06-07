/**
 * https://gist.github.com/kishalmi/5638574
 *
 * load shaders from files
 * @author lmg@kishalmi.net
 * @param shaders - (optinally nested) object with shader paths - to be replaced with actual file contents
 * @param callbackProgress - param: (total) progress as float
 * @param callbackSuccess - called once all shaders are loaded
 */
function loadShaders(shaders, callbackProgress, callbackSuccess) {
	// shift back if progress cb skipped
	if (!$.isFunction(callbackSuccess)) {
		callbackSuccess = callbackProgress;
		callbackProgress = null;
	}
 
	var loaded = 0, total = 0;
	var processObj = function (obj) {
		if (typeof(obj) === 'object')
			for (var key in obj)
				if (typeof(obj[key]) === 'string')
					loadShader(obj, key);
				else
					processObj(obj[key]);
	};
	var loadShader = function (obj, key) {
		total++;
		$.ajax({
			url: obj[key],
			dataType: 'text',
			xhr: function () {
				var xhr = new window.XMLHttpRequest();
				xhr.addEventListener("progress", function (event) {
					if (event.lengthComputable && event.loaded < event.total && callbackProgress)
						callbackProgress((loaded + event.loaded / event.total) / total);
				}, false);
				return xhr;
			},
			success: function (data) {
				// replace #includes in shaders, if already loaded
				var match, reInclude = /^#include ['"](.*)?['"]/mg;
				while (match = reInclude.exec(data)) {
					if (shaders.hasOwnProperty(match[1]))
						data = data.replace(match[0], shaders[match[1]]);
					else
						console.error('ERROR shader "' + obj[key] + '" #include "' + match[1] + '" not found!');
				}
 
				obj[key] = data;
			},
			complete: function () {
				loaded++;
				if (callbackProgress) callbackProgress(loaded / total);
				if (loaded < total) return;
				if (callbackSuccess) callbackSuccess();
			},
			error: function (jqXHR, textStatus, errorThrown) {
				console.error('ERROR loading "' + obj[key] + '": ' + textStatus);
			}
		});
	};
	processObj(shaders);
}