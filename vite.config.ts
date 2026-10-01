import { execFile } from 'node:child_process';
import { mkdir, writeFile } from 'node:fs/promises';
import { dirname } from 'node:path';
import { promisify } from 'node:util';

import { sveltekit } from '@sveltejs/kit/vite';
import tailwindcss from '@tailwindcss/vite';
import unplugin from 'unplugin-icons/vite';
import { defineConfig, type Plugin, type ViteDevServer } from 'vite';

const run = promisify(execFile);

function nixtojson(attr: string, name: string): Plugin {
  let server: ViteDevServer | undefined;
  const path = 'src/lib/generated/' + name;

  async function generate() {
    try {
      const { stdout } = await run('nix', ['eval', '--json', attr]);
      await mkdir(dirname(path), { recursive: true });
      await writeFile(path, stdout);
    } catch (e) {
      if (!server) throw e;
      const message = `nixtojson ${attr}:\n${(e as { stderr?: string }).stderr || e}`;
      server.config.logger.error(message);
      server.ws.send({ type: 'error', err: { message, stack: '' } });
    }
  }

  return {
    name: `nix-to-json:${name}`,
    buildStart: generate,
    configureServer(s) {
      server = s;
      s.watcher.on('change', (file) => /(\.nix|flake\.lock)$/.test(file) && generate());
    },
  };
}

export default defineConfig({
  plugins: [
    nixtojson('.#lib.cv.config', 'cv.json'),
    sveltekit(),
    tailwindcss(),
    unplugin({
      compiler: 'svelte',
      iconCustomizer(_collection, _icon, props) {
        props['aria-hidden'] = 'true';
      },
    }),
  ],
});
