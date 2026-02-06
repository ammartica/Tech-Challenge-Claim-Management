import { useState } from 'react'
import Login from "./pages/Login"
import Claims from "./pages/Claims"
import './App.css'

// function App() {
//   return <Login />;
// }
function App() {
  const [authed, setAuthed] = useState(!!localStorage.getItem("token"));

  if (!authed) return <Login onLoggedIn={() => setAuthed(true)} />;
  return <Claims />;
}

export default App
