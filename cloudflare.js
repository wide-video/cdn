const fs = require('fs');
const path = require('path');
const root = __dirname;

const ignoredPaths = [
	/\/ffmpeg\/0\.[0-7]/,
	/\/piper\/0\.0\.0\//,
	/\/rive\/2\.7/
]

let headerRulesCount = 1;

let headers = `/*
	Access-Control-Allow-Headers: *
	Access-Control-Allow-Origin: *
	Access-Control-Expose-Headers: *
	Cache-Control: public, max-age=604800, s-maxage=604800, immutable
	Cross-Origin-Opener-Policy: same-origin
	Cross-Origin-Embedder-Policy: require-corp
	Cross-Origin-Resource-Policy: cross-origin\n\n`;

function readFileSync(path) {
	try {
		return fs.readFileSync(path, 'utf8');
	} catch {}
}

function renameBrFilesSync(dir) {
	const files = fs.readdirSync(dir);
	const htaccess = readFileSync(path.join(dir, ".htaccess"));

	fileLoop:for(const file of files) {
		const filePath = path.join(dir, file);
		const stats = fs.statSync(filePath);

		for(const ignoredPath of ignoredPaths)
			if(filePath.match(ignoredPath)) {
				console.log(`Ignore path ${filePath} by rule ${ignoredPath}`);
				continue fileLoop;
			}

		if(stats.isDirectory()) {
			renameBrFilesSync(filePath);
			continue;
		} 
		
		if(stats.isFile() && path.extname(file) === '.br') {
			const newFilePath = filePath.replace(/\.br$/, '');
			fs.renameSync(filePath, newFilePath);
			console.log(`Renamed: ${filePath} -> ${newFilePath}`);

			headerRulesCount++;
			headers += `/${path.relative(root, newFilePath)}\n`
				+ `\tContent-Encoding: br\n`;

			if(htaccess) {
				const filePattern = file.replaceAll(".", "\\.").replace(".br", "\\.br");
				const pattern = `<FilesMatch.*?${filePattern}.*?x-content-length (\\d+)`;
				const match = htaccess.match(new RegExp(pattern, "s"));
				if(match && match.length > 0)
					headers += `\tx-content-length: ${match[1]}\n`;
			}

			headers += "\n";
		}
	}
}

renameBrFilesSync(root);

console.log(`creating _headers files with ${headerRulesCount} rules.`)
console.log(headers);
fs.writeFileSync("_headers", headers, 'utf8');