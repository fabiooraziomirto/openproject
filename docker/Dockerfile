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

# --- Rails initializer: injects CSS into every page via Redmine hook ---
COPY docker/hooks/custom_theme.rb /app/config/initializers/99_custom_theme.rb

# --- Fix permissions ---
RUN chown app:app \
      /app/public/assets/custom_theme.css \
      /app/public/assets/custom_fonts.css \
      /app/public/assets/custom_logo.png \
      /app/public/favicon.ico \
      /app/config/initializers/99_custom_theme.rb

USER app
