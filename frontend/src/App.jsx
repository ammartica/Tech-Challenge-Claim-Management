import { useState } from "react";
import Login from "./pages/Login";
import Claims from "./pages/Claims";
import ImportClaims from "./pages/ImportClaims";

function App() {
  const [authed, setAuthed] = useState(!!localStorage.getItem("token"));
  const [page, setPage] = useState("claims");

  if (!authed) return <Login onLoggedIn={() => setAuthed(true)} />;

  if (page === "import") {
    return <ImportClaims onDone={() => setPage("claims")} />;
  }

  return <Claims onGoImport={() => setPage("import")} />;
}

export default App;

