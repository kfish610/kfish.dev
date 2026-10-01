<script lang="ts">
  import './layout.css';

  import favicon from '$lib/assets/favicon.ico';
  import apple from '$lib/assets/favicon/apple-touch-icon.png';
  import android from '$lib/assets/favicon/site.webmanifest';

  let { children } = $props();
</script>

<svelte:head>
  <link rel="icon" href={favicon} sizes="16x16 32x32 48x48" />
  <link rel="apple-touch-icon" href={apple} />
  <link rel="manifest" href={android} />
</svelte:head>
{@render children()}
