const API_URL = import.meta.env.VITE_API_URL;

export function authHeaders() {
  const token = localStorage.getItem("token");
  return token ? { Authorization: `Bearer ${token}` } : {};
}

export async function apiGet(path, opts = {}) {
  const res = await fetch(`${API_URL}${path}`, {
    ...opts,
    headers: {
      ...(opts.headers || {}),
      ...authHeaders(),
    },
  });

  if (!res.ok) throw new Error(`Request failed: ${res.status}`);
  return res;
}
