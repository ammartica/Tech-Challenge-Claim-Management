/*
summary: 
api.js abstracts fetch calls to the backend. 
It reads the base API URL from environment variables 
and automatically attaches the JWT token in the Authorization header for protected endpoints. 
This keeps API logic centralized and reusable.
*/


//reads env var from vite
//so all requests go there
const API_URL = import.meta.env.VITE_API_URL;

//gets jwt from localstorage
export function authHeaders() {
  const token = localStorage.getItem("token");
  return token ? { Authorization: `Bearer ${token}` } : {};
}

//reausable helper for get requests
export async function apiGet(path, opts = {}) {
  //calls localhost:3000 + /claims
  const res = await fetch(`${API_URL}${path}`, {
    ...opts,
    headers: {
      ...(opts.headers || {}),
      ...authHeaders(),
    },
  });
  //basically, keeps custom headers passed in
  //adds auth header automatically to the get
  //every request includes the jwt

  //if req fails, my ui catches it
  if (!res.ok) throw new Error(`Request failed: ${res.status}`);
  return res;
}
