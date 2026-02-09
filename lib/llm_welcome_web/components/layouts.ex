defmodule LlmWelcomeWeb.Layouts do
  @moduledoc """
  This module holds layouts and related functionality
  used by your application.
  """
  use LlmWelcomeWeb, :html

  # Embed all files in layouts/* within this module.
  # The default root.html.heex file contains the HTML
  # skeleton of your application, namely HTML headers
  # and other static content.
  embed_templates "layouts/*"

  @doc """
  Renders your app layout.

  This function is typically invoked from every template,
  and it often contains your application menu, sidebar,
  or similar.

  ## Examples

      <Layouts.app flash={@flash}>
        <h1>Content</h1>
      </Layouts.app>

  """
  attr :flash, :map, required: true, doc: "the map of flash messages"

  attr :current_scope, :map,
    default: nil,
    doc: "the current [scope](https://hexdocs.pm/phoenix/scopes.html)"

  slot :inner_block, required: true

  def app(assigns) do
    ~H"""
    <div class="relative isolate min-h-screen">
      <div class="pointer-events-none absolute inset-0 -z-10">
        <div class="absolute -top-32 left-1/2 h-72 w-72 -translate-x-1/2 rounded-full bg-primary/20 blur-[120px] [[data-theme=dark]_&]:bg-primary/10" />
        <div class="absolute -bottom-20 right-10 h-64 w-64 rounded-full bg-secondary/20 blur-[120px] [[data-theme=dark]_&]:bg-secondary/10" />
      </div>

      <div class="mx-auto flex w-full max-w-7xl flex-1 flex-col px-3 pb-8 pt-5 sm:px-6 lg:px-8">
        <header class="flex flex-nowrap items-center justify-between gap-2 sm:gap-4">
          <a
            href="/"
            class="font-display text-base font-semibold tracking-tight text-base-content sm:text-xl"
          >
            <span class="text-primary">llm</span>welcome<span class="text-base-content/50">.dev</span>
          </a>
          <div class="flex items-center gap-2 sm:gap-3">
            <a
              href="https://github.com/apps/llm-welcome"
              target="_blank"
              rel="noopener"
              class="inline-flex items-center gap-2 rounded-full border border-base-300 bg-base-100 px-2.5 py-1.5 text-xs font-semibold text-base-content shadow-sm transition hover:border-base-content/40 sm:px-4 sm:py-2 sm:text-sm"
            >
              Setup <.icon name="hero-arrow-up-right" class="size-3 opacity-60 sm:size-4" />
            </a>
            <.theme_toggle />
          </div>
        </header>

        <main class="mt-8 flex-1 px-1 pb-2 sm:px-2 sm:pb-4">
          {render_slot(@inner_block)}
        </main>

        <footer class="mt-8 text-center text-sm text-base-content/60">
          Open source issues for LLM-assisted contributors
        </footer>
      </div>
    </div>

    <.flash_group flash={@flash} />
    """
  end

  @doc """
  Shows the flash group with standard titles and content.

  ## Examples

      <.flash_group flash={@flash} />
  """
  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :id, :string, default: "flash-group", doc: "the optional id of flash container"

  def flash_group(assigns) do
    ~H"""
    <div id={@id} aria-live="polite">
      <.flash kind={:info} flash={@flash} />
      <.flash kind={:error} flash={@flash} />

      <.flash
        id="client-error"
        kind={:error}
        title={gettext("We can't find the internet")}
        phx-disconnected={show(".phx-client-error #client-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#client-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>

      <.flash
        id="server-error"
        kind={:error}
        title={gettext("Something went wrong!")}
        phx-disconnected={show(".phx-server-error #server-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#server-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>
    </div>
    """
  end

  @doc """
  Provides dark vs light theme toggle based on themes defined in app.css.

  See <head> in root.html.heex which applies the theme before page load.
  """
  def theme_toggle(assigns) do
    ~H"""
    <div class="relative flex items-center rounded-full border border-base-300 bg-base-100 p-1 shadow-sm">
      <div class="absolute left-1 top-1 h-6 w-6 rounded-full bg-base-200 transition-[left] [[data-theme=light]_&]:left-[28px] [[data-theme=dark]_&]:left-[52px]" />

      <button
        id="theme-system"
        class="relative z-10 flex h-6 w-6 items-center justify-center"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="system"
      >
        <.icon name="hero-computer-desktop-micro" class="size-3 opacity-70" />
      </button>

      <button
        id="theme-light"
        class="relative z-10 flex h-6 w-6 items-center justify-center"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="light"
      >
        <.icon name="hero-sun-micro" class="size-3 text-amber-500" />
      </button>

      <button
        id="theme-dark"
        class="relative z-10 flex h-6 w-6 items-center justify-center"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="dark"
      >
        <.icon name="hero-moon-micro" class="size-3 opacity-70" />
      </button>
    </div>
    """
  end
end
