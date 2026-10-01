<script lang="ts">
  import { afterNavigate } from '$app/navigation';
  import { resolve } from '$app/paths';
  import icon from '$lib/assets/cogs-transparent-big.png';
  import IconGithub from '~icons/fa7-brands/github';
  import IconLinkedin from '~icons/fa7-brands/linkedin';
  import IconBars from '~icons/fa7-solid/bars';
  import IconEnvelope from '~icons/fa7-solid/envelope';

  let categories: string[] = [
    'About',
    'Publications',
    'Experience',
    'Projects',
    // 'Teaching',
    // 'Service',
    'News',
  ];

  let links = [
    { href: 'mailto:kf23@illinois.edu', label: 'Email', icon: IconEnvelope },
    { href: 'https://github.com/kfish610', label: 'GitHub', icon: IconGithub },
    { href: 'https://www.linkedin.com/in/kfish610', label: 'LinkedIn', icon: IconLinkedin },
  ];

  let open = $state(false);
  afterNavigate(() => (open = false));
</script>

<nav class="fixed start-0 top-0 z-20 h-16 w-full">
  <div class="flex h-full w-full flex-row items-center space-x-7 px-4">
    <div class="me-5 flex md:hidden">
      <button
        type="button"
        class="items-end md:hidden"
        aria-controls="navbar-sticky"
        aria-expanded={open}
        onclick={() => (open = !open)}
      >
        <span class="sr-only">{open ? 'Close' : 'Open'} main menu</span>
        <IconBars class="h-7 w-7" />
      </button>
    </div>
    <a href={resolve('/')} class="flex h-full items-center space-x-3" aria-current="page">
      <img class="h-7 w-7 rounded-full" src={icon} alt="Personal Logo" />
      <span class="h-auto w-auto text-xl font-semibold">Kevin Fisher</span>
    </a>
    <!-- Below md this is a dropdown under the bar; from md up it sits inline. -->
    <div
      class={[
        open ? 'flex' : 'hidden',
        'absolute start-0 top-16 w-full p-4 dark:bg-zinc-900',
        'md:static md:flex md:h-full md:w-auto md:items-center md:p-0 md:dark:bg-transparent',
      ]}
      id="navbar-sticky"
    >
      <ul class="flex flex-col space-y-3 md:flex-row md:space-y-0 md:space-x-7">
        {#each categories as category (category)}
          <li>
            <a href="#/{category.toLowerCase()}" class="block">{category}</a>
          </li>
        {/each}
      </ul>
    </div>
    <div class="ms-auto flex items-center space-x-3">
      <!-- rel="external": these are off-site links, so skip the SvelteKit router. -->
      {#each links as { href, label, icon: Icon } (href)}
        <a {href} rel="external" aria-label={label}>
          <Icon class="size-6" />
        </a>
      {/each}
    </div>
  </div>
</nav>
