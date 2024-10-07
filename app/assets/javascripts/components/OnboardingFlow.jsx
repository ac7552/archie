import React, { useState } from 'react';
import OnboardingScreen from './OnboardingScreen';

const OnboardingFlow = () => {
  const [step, setStep] = useState(1);

  const nextStep = () => setStep(step + 1);
  const prevStep = () => setStep(step - 1);

  const screens = [
    { title: "Freelance", description: "Freelance for anyone and keep them accountable.", buttonText: "Next", showBack: false, showSkip: true },
    { title: "Contracts", description: "Built AI contracts in minutes.", buttonText: "Next", showBack: true, showSkip: true },
    { title: "Project", description: "Make your Project Secure", buttonText: "Finish", showBack: true, showSkip: false }
  ];

  return (
    <OnboardingScreen
      title={screens[step - 1].title}
      description={screens[step - 1].description}
      buttonText={screens[step - 1].buttonText}
      onNext={step < screens.length ? nextStep : () => alert('Onboarding complete!')}
      onBack={prevStep}
      showBack={screens[step - 1].showBack}
      showSkip={screens[step - 1].showSkip}
    />
  );
};

export default OnboardingFlow;