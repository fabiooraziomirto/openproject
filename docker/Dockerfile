FROM openproject/openproject:17-slim

LABEL org.opencontainers.image.title="OpenProject Custom"
LABEL org.opencontainers.image.description="OpenProject with dark tech theme"
LABEL org.opencontainers.image.source="https://github.com/fabiooraziomirto/openproject"

USER root

# --- Theme CSS (served as static assets, no fingerprinting needed) ---
COPY theme/custom_variables.css /app/public/assets/custom_theme.css
COPY theme/fonts.css             /app/public/assets/custom_fonts.css

# --- Custom logo and favicon ---
COPY assets/logos/logo.png       /app/public/assets/custom_logo.png
COPY assets/favicons/favicon.ico /app/public/favicon.ico

# --- Inject CSS links into base layout (before </head>) ---
# Using sed on the base layout is more reliable than an initializer
# because it doesn't depend on Rails/OpenProject load order.
RUN sed -i \
  's|<%= call_hook :view_layouts_base_html_head %>|<%= call_hook :view_layouts_base_html_head %>\n    <script>document.documentElement.dataset.colorMode=\x27dark\x27;<\/script>\n    <link rel="stylesheet" href="\/assets\/custom_fonts.css">\n    <link rel="stylesheet" href="\/assets\/custom_theme.css">|' \
  /app/app/views/layouts/base.html.erb

# --- Fix permissions ---
RUN chown app:app \
      /app/public/assets/custom_theme.css \
      /app/public/assets/custom_fonts.css \
      /app/public/assets/custom_logo.png \
      /app/public/favicon.ico \
      /app/app/views/layouts/base.html.erb

USER app
