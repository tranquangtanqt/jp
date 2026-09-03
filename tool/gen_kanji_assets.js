// One-off generator: converts the Kanji/radical TypeScript tuple data from the
// original React project into the JSON assets this app bundles.
//
// Run only when the React source changes:
//   node tool/gen_kanji_assets.js /path/to/React/home
//
// Requires the React project's node_modules (it uses its local `tsc`).
// Outputs: assets/data/kanji/{categories,n5,radicals}.json

const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');
const os = require('os');

const reactRoot = process.argv[2] || 'D:/Project/Tantq/React/home';
const kanjiDir = path.join(reactRoot, 'src/pages/learning/japan/kanji');
const assetsDir = path.resolve(__dirname, '../assets/data/kanji');
const outDir = fs.mkdtempSync(path.join(os.tmpdir(), 'kanji-build-'));

const tsc = path.join(reactRoot, 'node_modules/.bin/tsc' + (process.platform === 'win32' ? '.cmd' : ''));
const files = ['dto/index.ts', 'radicals.ts', 'data.ts'].map((f) => path.join(kanjiDir, f));

execSync(
  `"${tsc}" ${files.map((f) => `"${f}"`).join(' ')} --outDir "${outDir}" ` +
    `--module commonjs --target es2019 --moduleResolution node --skipLibCheck --noEmitOnError false --rootDir "${kanjiDir}"`,
  { stdio: 'inherit' },
);

const data = require(path.join(outDir, 'data.js'));

fs.writeFileSync(path.join(assetsDir, 'categories.json'), JSON.stringify(data.KANJI_CATEGORIES, null, 2));
fs.writeFileSync(path.join(assetsDir, 'n5.json'), JSON.stringify(data.KANJI_LIST, null, 2));
fs.writeFileSync(path.join(assetsDir, 'radicals.json'), JSON.stringify(data.RADICALS, null, 2));
fs.rmSync(outDir, { recursive: true, force: true });

console.log(
  `categories=${data.KANJI_CATEGORIES.length} kanji=${data.KANJI_LIST.length} radicals=${data.RADICALS.length}`,
);
