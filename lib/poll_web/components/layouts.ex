defmodule PollWeb.Layouts do
  @moduledoc """
  This module holds layouts and related functionality
  used by your application.
  """
  use PollWeb, :html

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
    <div class="relative min-h-screen bg-canvas text-slate-900 dark:text-slate-50">
      <div class="noise-layer pointer-events-none absolute inset-0 opacity-30 mix-blend-soft-light dark:opacity-20"></div>
      <div class="relative z-10 mx-auto max-w-6xl px-4 pb-16 pt-10 sm:px-6 lg:px-8">
        <header class="mb-10 flex flex-wrap items-center justify-between gap-4">
          <a
            href="/"
            class="flex items-center gap-3 rounded-full bg-white/70 px-4 py-2 shadow-sm ring-1 ring-black/5 backdrop-blur dark:bg-slate-900/70 dark:ring-white/10"
          >
            <img src={~p"/images/logo.svg"} width="32" height="32" />
            <div class="leading-tight">
              <p class="text-sm font-semibold tracking-tight">Pulse Polls</p>
              <p class="text-[11px] uppercase tracking-[0.08em] text-slate-500 dark:text-slate-400">
                live voting · v{Application.spec(:phoenix, :vsn)}
              </p>
            </div>
          </a>

          <div class="flex items-center gap-2">
            <.theme_toggle />
          </div>
        </header>

        <main>
          {render_slot(@inner_block)}
        </main>
      </div>
      <.flash_group flash={@flash} />
    </div>
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
    <div class="flex items-center gap-1 rounded-full bg-slate-100/70 px-1 py-1 ring-1 ring-black/5 backdrop-blur dark:bg-slate-800/70 dark:ring-white/10">
      <button
        class="inline-flex items-center gap-1 rounded-full px-2 py-1 text-xs font-semibold text-slate-600 transition hover:bg-white/90 hover:text-slate-900 dark:text-slate-200 dark:hover:bg-slate-700/80"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="system"
      >
        <.icon name="hero-computer-desktop" class="h-4 w-4" /> System
      </button>

      <button
        class="inline-flex items-center gap-1 rounded-full px-2 py-1 text-xs font-semibold text-slate-600 transition hover:bg-white/90 hover:text-slate-900 dark:text-slate-200 dark:hover:bg-slate-700/80"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="light"
      >
        <.icon name="hero-sun" class="h-4 w-4" /> Light
      </button>

      <button
        class="inline-flex items-center gap-1 rounded-full px-2 py-1 text-xs font-semibold text-slate-600 transition hover:bg-white/90 hover:text-slate-900 dark:text-slate-200 dark:hover:bg-slate-700/80"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="dark"
      >
        <.icon name="hero-moon" class="h-4 w-4" /> Dark
      </button>
    </div>
    """
  end
end
