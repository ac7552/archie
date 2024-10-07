import React from 'react';

const OnboardingScreen = ({ title, description, buttonText, onNext, onBack, showBack, showSkip }) => (
  <div className="onboarding">
    {showBack && <button onClick={onBack}>Back</button>}
    <h2>{title}</h2>
    <p>{description}</p>
    <button onClick={onNext}>{buttonText}</button>
    {showSkip && <button onClick={onNext}>Skip</button>}
  </div>
);

export default OnboardingScreen;