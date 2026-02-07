// import { useState } from "react";
// import Login from "./pages/Login";
// import Claims from "./pages/Claims";
// import ImportClaims from "./pages/ImportClaims";

// function App() {
//   const [authed, setAuthed] = useState(!!localStorage.getItem("token"));
//   const [page, setPage] = useState("claims");

//   if (!authed) return <Login onLoggedIn={() => setAuthed(true)} />;

//   if (page === "import") {
//     return <ImportClaims onDone={() => setPage("claims")} />;
//   }

//   return <Claims onGoImport={() => setPage("import")} />;
// }

// export default App;


import { useMemo, useState } from "react";
import { Layout, Menu, Button, Typography, Space } from "antd";
import Login from "./pages/Login";
import Claims from "./pages/Claims";
import ImportClaims from "./pages/ImportClaims";

const { Header, Content } = Layout;

function App() {
  const [authed, setAuthed] = useState(!!localStorage.getItem("token"));
  const [page, setPage] = useState("claims"); // "claims" | "import"

  const email = useMemo(() => localStorage.getItem("email"), []);

  const logout = () => {
    localStorage.removeItem("token");
    localStorage.removeItem("email");
    window.location.reload();
  };

  if (!authed) {
    return <Login onLoggedIn={() => setAuthed(true)} />;
  }

  const items = [
    { key: "claims", label: "Claims" },
    { key: "import", label: "Import" },
  ];

  return (
    <Layout style={{ minHeight: "100vh" }}>
      <Header style={{ display: "flex", alignItems: "center", gap: 16 }}>
        <Typography.Title level={4} style={{ margin: 0, color: "white" }}>
          Medical Claims
        </Typography.Title>

        <Menu
          theme="dark"
          mode="horizontal"
          selectedKeys={[page]}
          items={items}
          onClick={(e) => setPage(e.key)}
          style={{ flex: 1, marginLeft: 24 }}
        />

        <Space>
          {email ? <span style={{ color: "rgba(255,255,255,0.75)" }}>{email}</span> : null}
          <Button onClick={logout}>Logout</Button>
        </Space>
      </Header>

      <Content style={{ padding: 32 }}>
        <div style={{ maxWidth: 1100, margin: "0 auto" }}>
          {page === "claims" ? <Claims /> : <ImportClaims />}
        </div>
      </Content>
    </Layout>
  );
}

export default App;

