<script lang="ts">
  import icon from '$lib/assets/cogs-transparent-big.png';

  let categories: string[] = [
    'About',
    'Publications',
    'Experience',
    'Projects',
    // 'Teaching',
    // 'Service',
    'News',
  ];
</script>

<div
  class="flex h-dvh w-dvw flex-col dark:bg-zinc-900 dark:text-neutral-200"
  style="color-scheme: dark"
  id="app"
>
  <nav class="fixed start-0 top-0 z-20 h-16 w-full">
    <div class="flex h-full w-full flex-row items-center space-x-7 px-4">
      <div class="me-5 flex md:hidden">
        <button
          data-collapse-toggle="navbar-sticky"
          type="button"
          class="items-end md:hidden"
          aria-controls="navbar-sticky"
          aria-expanded="false"
        >
          <span class="sr-only">Open main menu</span>
          <svg
            class="h-7 w-7"
            aria-hidden="true"
            xmlns="http://www.w3.org/2000/svg"
            width="20"
            height="20"
            fill="none"
            viewBox="0 0 24 24"
          >
            <path
              stroke="currentColor"
              stroke-linecap="round"
              stroke-width="2"
              d="M5 7h14M5 12h14M5 17h14"
            />
          </svg>
        </button>
      </div>
      <a href="/" class="flex h-full items-center space-x-3" aria-current="page">
        <img class="h-7 w-7 rounded-full" src={icon} alt="Personal Logo" />
        <span class="h-auto w-auto text-xl font-semibold">Kevin Fisher</span>
      </a>
      <div class="hidden h-full items-center md:flex md:w-auto" id="navbar-sticky">
        <ul class="flex space-x-7 md:p-0">
          {#each categories as category}
            <li>
              <a href="#/{category.toLowerCase()}" class="text- block">{category}</a>
            </li>
          {/each}
        </ul>
      </div>
      <div class="ms-auto flex items-center space-x-3">
        <a href="mailto:kf23@illinois.edu" aria-label="Email">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 24 24"
            class="size-6 fill-neutral-200"
          >
            <path
              d="M1.5 8.67v8.58a3 3 0 0 0 3 3h15a3 3 0 0 0 3-3V8.67l-8.928 5.493a3 3 0 0 1-3.144 0L1.5 8.67Z"
            />
            <path
              d="M22.5 6.908V6.75a3 3 0 0 0-3-3h-15a3 3 0 0 0-3 3v.158l9.714 5.978a1.5 1.5 0 0 0 1.572 0L22.5 6.908Z"
            />
          </svg>
        </a>
        <a href="https://github.com/kfish610" aria-label="GitHub">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 24 24"
            class="size-6 fill-neutral-200"
          >
            <path
              fill-rule="evenodd"
              clip-rule="evenodd"
              d="M12 2C6.477 2 2 6.463 2 11.97c0 4.404 2.865 8.14 6.839 9.458.5.092.682-.216.682-.48 0-.236-.008-.864-.013-1.695-2.782.602-3.369-1.337-3.369-1.337-.454-1.151-1.11-1.458-1.11-1.458-.908-.618.069-.606.069-.606 1.003.07 1.531 1.027 1.531 1.027.892 1.524 2.341 1.084 2.91.828.092-.643.35-1.083.636-1.332-2.22-.251-4.555-1.107-4.555-4.927 0-1.088.39-1.979 1.029-2.675-.103-.252-.446-1.266.098-2.638 0 0 .84-.268 2.75 1.022A9.607 9.607 0 0 1 12 6.82c.85.004 1.705.114 2.504.336 1.909-1.29 2.747-1.022 2.747-1.022.546 1.372.202 2.386.1 2.638.64.696 1.028 1.587 1.028 2.675 0 3.83-2.339 4.673-4.566 4.92.359.307.678.915.678 1.846 0 1.332-.012 2.407-.012 2.734 0 .267.18.577.688.48 3.97-1.32 6.833-5.054 6.833-9.458C22 6.463 17.522 2 12 2Z"
            />
          </svg>
        </a>
        <a href="https://www.linkedin.com/in/kfish610" aria-label="LinkedIn">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 24 24"
            class="size-6 fill-neutral-200"
          >
            <path
              d="M20.447 20.452h-3.554v-5.569c0-1.328-.027-3.037-1.852-3.037-1.853 0-2.136 1.445-2.136 2.939v5.667H9.351V9h3.414v1.561h.046c.477-.9 1.637-1.85 3.37-1.85 3.601 0 4.267 2.37 4.267 5.455v6.286zM5.337 7.433c-1.144 0-2.063-.926-2.063-2.065 0-1.138.92-2.063 2.063-2.063 1.14 0 2.064.925 2.064 2.063 0 1.139-.925 2.065-2.064 2.065zm1.782 13.019H3.555V9h3.564v11.452zM22.225 0H1.771C.792 0 0 .774 0 1.729v20.542C0 23.227.792 24 1.771 24h20.451C23.2 24 24 23.227 24 22.271V1.729C24 .774 23.2 0 22.222 0h.003z"
            />
          </svg>
        </a>
      </div>
    </div>
  </nav>
  <div class="mt-16 flex-1 rounded-t-2xl p-4 dark:bg-zinc-800">A A</div>
</div>
