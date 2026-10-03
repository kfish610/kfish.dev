import { execFile } from 'node:child_process';
import { mkdir, readFile, writeFile } from 'node:fs/promises';
import { dirname } from 'node:path';
import { promisify } from 'node:util';

import { sveltekit } from '@sveltejs/kit/vite';
import tailwindcss from '@tailwindcss/vite';
import unplugin from 'unplugin-icons/vite';
import { defineConfig, type Plugin, type ViteDevServer } from 'vite';

const run = promisify(execFile);

function nixbuild(attr: string, path: string): Plugin {
  let server: ViteDevServer | undefined;

  async function generate() {
    try {
      const { stdout } = await run('nix', ['build', '--no-link', '--print-out-paths', attr]);
      const contents = await readFile(stdout.trim());
      await mkdir(dirname(path), { recursive: true });
      await writeFile(path, contents);
    } catch (e) {
      if (!server) throw e;
      const message = `nix build ${attr}:\n${(e as { stderr?: string }).stderr || e}`;
      server.config.logger.error(message);
      server.ws.send({ type: 'error', err: { message, stack: '' } });
    }
  }

  return {
    name: `nix-build:${path}`,
    buildStart: generate,
    configureServer(s) {
      server = s;
      s.watcher.on('change', (file) => /(\.nix|\.typ|flake\.lock)$/.test(file) && generate());
    },
  };
}

export default defineConfig({
  plugins: [
    nixbuild('.#cv-json', 'src/lib/generated/cv.json'),
    nixbuild('.#cv-pdf', 'static/cv.pdf'),
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
