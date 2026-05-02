# Copied to /app/config/initializers/99_custom_theme.rb inside the Docker image.
#
# Registers an OpenProject hook listener that injects the custom dark theme
# stylesheet and font CSS into every page's <head> via the
# `view_layouts_base_html_head` hook called in app/views/layouts/base.html.erb.
#
# The CSS files are served as static assets from /app/public/assets/ (copied
# by the Dockerfile COPY instructions) and need no asset pipeline fingerprinting.

module OpenProjectCustomTheme
  class HookListener < OpenProject::Hook::ViewListener
    def view_layouts_base_html_head(context = {})
      # Inject dark-mode attribute early (before body renders) to prevent
      # Primer color flash, then load theme and font overrides.
      <<~HTML.html_safe
        <script>document.documentElement.dataset.colorMode='dark';</script>
        <link rel="stylesheet" href="/assets/custom_fonts.css">
        <link rel="stylesheet" href="/assets/custom_theme.css">
      HTML
    end
  end
end

OpenProject::Hook.add_listener(OpenProjectCustomTheme::HookListener)
