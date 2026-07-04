function animate() {
  document.querySelectorAll('#chat-list .chat-item').forEach((el) => {
    window.setTimeout(() => el.classList.add('vis'), Number(el.dataset.d) || 0);
  });

  document.querySelectorAll('#pipeline-stages .job-card').forEach((el) => {
    window.setTimeout(() => el.classList.add('vis'), Number(el.dataset.d) || 0);
  });
}

function animatePipelineFlow() {
  const stageGroups = Array.from(document.querySelectorAll('#pipeline-stages .stage-group'));
  if (stageGroups.length === 0) {
    return;
  }

  let activeIndex = 0;
  window.setInterval(() => {
    stageGroups.forEach((group, index) => {
      group.classList.toggle('active', index === activeIndex);
    });
    activeIndex = (activeIndex + 1) % stageGroups.length;
  }, 1200);
}

function setupStickyMobileCta() {
  const hero = document.querySelector('.hero');
  const stickyCta = document.querySelector('.mobile-sticky-cta');

  if (!hero || !stickyCta || window.innerWidth > 768) {
    return;
  }

  const observer = new IntersectionObserver(
    (entries) => {
      stickyCta.classList.toggle('visible', !entries[0].isIntersecting);
    },
    { threshold: 0.2 }
  );

  observer.observe(hero);
}

const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
if (prefersReducedMotion) {
  document.querySelectorAll('.chat-item, .job-card').forEach((el) => el.classList.add('vis'));
} else {
  const mockup = document.querySelector('.mockup-section');
  if (mockup) {
    const observer = new IntersectionObserver(
      (entries) => {
        if (entries[0].isIntersecting) {
          animate();
          animatePipelineFlow();
          observer.disconnect();
        }
      },
      { threshold: 0.15 }
    );

    observer.observe(mockup);
  }
}

setupStickyMobileCta();
