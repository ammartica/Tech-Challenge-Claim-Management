import { Button, Form, Input, Card, Layout, Typography, message } from "antd";

const { Content } = Layout;
const { Title, Text } = Typography;

const Login = ({ onLoggedIn }) => {
  const onFinish = async (values) => {
    try {
      const res = await fetch(`${import.meta.env.VITE_API_URL}/login`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(values),
      });

      const data = await res.json();
      if (!data.token) throw new Error();

      localStorage.setItem("token", data.token);
      onLoggedIn?.();
    } catch {
      message.error("Invalid email or password");
    }
  };

  return (
    <Layout style={{ minHeight: "100vh" }}>
      <Content style={{ display: "flex", justifyContent: "center", alignItems: "center" }}>
        <Card style={{ width: 360 }}>
          <Title level={3}>Medical Claims</Title>
          <Text type="secondary">Sign in to continue</Text>

          <Form layout="vertical" onFinish={onFinish} style={{ marginTop: 24 }}>
            <Form.Item name="email" label="Email" rules={[{ required: true }]}>
              <Input />
            </Form.Item>
            <Form.Item name="password" label="Password" rules={[{ required: true }]}>
              <Input.Password />
            </Form.Item>
            <Button type="primary" htmlType="submit" block>
              Login
            </Button>
          </Form>
        </Card>
      </Content>
    </Layout>
  );
};

export default Login;

// const Login = ({ onLoggedIn }) => {
//   const onFinish = async (values) => {
//     const res = await fetch(`${import.meta.env.VITE_API_URL}/login`, {
//       method: "POST",
//       headers: { "Content-Type": "application/json" },
//       body: JSON.stringify(values),
//     });

//     const data = await res.json();
//     if (data.token) {
//       localStorage.setItem("token", data.token);
//       onLoggedIn?.();
//     } else {
//       alert("Login failed");
//     }
//   };

//   return (
//     <div style={{ display: "flex", height: "100vh", justifyContent: "center", alignItems: "center" }}>
//       <Card title="Login" style={{ width: 320 }}>
//         <Form onFinish={onFinish}>
//           <Form.Item name="email" rules={[{ required: true }]}>
//             <Input placeholder="Email" />
//           </Form.Item>
//           <Form.Item name="password" rules={[{ required: true }]}>
//             <Input.Password placeholder="Password" />
//           </Form.Item>
//           <Button type="primary" htmlType="submit" block>
//             Login
//           </Button>
//         </Form>
//       </Card>
//     </div>
//   );
// };

// export default Login;
