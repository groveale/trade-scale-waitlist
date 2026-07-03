function animate() {
  document.querySelectorAll('#chat-list .chat-item').forEach((el) => {
    window.setTimeout(() => el.classList.add('vis'), Number(el.dataset.d) || 0);
  });

  document.querySelectorAll('#pipeline-stages .job-card').forEach((el) => {
    window.setTimeout(() => el.classList.add('vis'), Number(el.dataset.d) || 0);
  });
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
          observer.disconnect();
        }
      },
      { threshold: 0.15 }
    );

    observer.observe(mockup);
  }
}
