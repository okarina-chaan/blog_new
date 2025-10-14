module.exports = {
  content: [
    './app/views/**/*.{erb,html,haml,slim}',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js'
  ],
  theme: { extend: {} },
  plugins: [ require('daisyui') ],
  daisyui: {
    themes: ["emerald"]
  }
};

