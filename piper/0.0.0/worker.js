self.addEventListener("message", async (event) => {
	const data = event.data;
	if(data.kind === "init")
		init(data.version, data.model, data.input, data.blobs);
})

const getBlob = async (url, blobs) => new Promise(resolve => {
	const cached = blobs[url];
	if(cached)
		return resolve(cached);
	const id = new Date().getTime();
	let xContentLength;
	self.postMessage({kind:"fetch", id, url});

	const xhr = new XMLHttpRequest();
	xhr.responseType = "blob";
	xhr.onprogress = event => 
		self.postMessage({kind:"fetch", id, url, total:xContentLength ?? event.total, loaded:event.loaded})
	xhr.onreadystatechange = () => {
		if(xhr.readyState >= xhr.HEADERS_RECEIVED
			&& xContentLength === undefined
			&& xhr.getAllResponseHeaders().includes("x-content-length"))
			xContentLength = Number(xhr.getResponseHeader("x-content-length"));

		if(xhr.readyState === xhr.DONE) {
			self.postMessage({kind:"fetch", id, url, blob:xhr.response})
		 	resolve(xhr.response);
		}
	}
	xhr.open("GET", url);
	xhr.send();
});

async function init(version, model, input, blobs) {
	const piperJs = URL.createObjectURL(await getBlob("piper.js", blobs));
	const piperWasm = URL.createObjectURL(await getBlob("piper.wasm", blobs));
	const piperData = URL.createObjectURL(await getBlob("piper.data", blobs));

	importScripts(piperJs);

	const module = await createPiper({
		print:filename => {
			const item = input.find(item => item.output_file === filename);
			const file = new File([FS.readFile(filename)], filename, {type:"audio/wav"});
			self.postMessage({kind:"output", input:item, file});
		},
		printErr:message => {
			self.postMessage({kind:"stderr", message});
		},
		locateFile:(url, _scriptDirectory) => {
			if(url.endsWith(".wasm")) return piperWasm;
			if(url.endsWith(".data")) return piperData;
			return url;
		}
	});

	const FS = module.FS; 
	FS.mkdir("/proc/self/exe");
	FS.mkdir("/model");

	const files = [];
	let modelFile = "";
	for(const key of Object.keys(model.files)) {
		// https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/ar/ar_JO/kareem/medium/ar_JO-kareem-medium.onnx
		const url = `https://huggingface.co/wide-video/piper-voices-${version}/resolve/main/${key}`;
		const filename = key.split("/").pop();

		if(filename.endsWith(".onnx"))
			modelFile = filename;

		files.push(new File([await getBlob(url, blobs)], filename));
	}

	FS.mount(module.WORKERFS, {files}, "model");

	module.callMain(["--input", JSON.stringify(input), "--model", `/model/${modelFile}`, "--espeak_data", "/espeak-ng-data"]);

	self.postMessage({kind:"complete"});
}
