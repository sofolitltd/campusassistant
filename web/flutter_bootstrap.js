{{flutter_js}}
{{flutter_build_config}}


// Create splash container
const logoContainer = document.createElement("div");
logoContainer.className = "app-logo-container";
document.body.appendChild(logoContainer);

// Create logo image
const logoImage = document.createElement("img");
logoImage.src = "icons/splash.png";
logoImage.alt = "App Logo";
logoImage.className = "app-logo-scaling";
logoContainer.appendChild(logoImage);

// Start Flutter loader
_flutter.loader.load({
  onEntrypointLoaded: async function (engineInitializer) {
    const appRunner = await engineInitializer.initializeEngine();

    // Fade out the splash
    logoContainer.classList.add("fade-out");
    setTimeout(() => {
      if (document.body.contains(logoContainer)) {
        document.body.removeChild(logoContainer);
      }
    }, 400);

    await appRunner.runApp();
  },
});
