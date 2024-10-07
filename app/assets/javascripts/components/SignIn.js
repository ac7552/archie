import React, { useState } from 'react';

const SignIn = () => {
  const [formData, setFormData] = useState({ email: '', password: '' });

  const handleSubmit = async (event) => {
    event.preventDefault();
    const response = await fetch('/api/v1/users/sign_in', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ user: formData }),
    });

    if (response.ok) {
      alert('Sign in successful!');
    } else {
      alert('Sign in failed');
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
      <button type="submit">Sign In</button>
    </form>
  );
};

export default SignIn;
