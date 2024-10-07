import React, { useState } from 'react';

const SignUp = () => {
  const [formData, setFormData] = useState({ email: '', password: '', passwordConfirmation: '' });

  const handleSubmit = async (event) => {
    event.preventDefault();
    const response = await fetch('/api/v1/users', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ user: formData }),
    });

    if (response.ok) {
      alert('Sign up successful!');
    } else {
      alert('Sign up failed');
    }
  };

  const handleChange = (event) => {
    const { name, value } = event.target;
    setFormData({ ...formData, [name]: value });
  };

  return (
    <form onSubmit={handleSubmit}>
      <input type="email" name="email" placeholder="Email" onChange={handleChange} required />
      <input type="password" name="password" placeholder="Password" onChange={handleChange} required />
      <input type="password" name="passwordConfirmation" placeholder="Confirm Password" onChange={handleChange} required />
      <button type="submit">Sign Up</button>
    </form>
  );
};

export default SignUp;