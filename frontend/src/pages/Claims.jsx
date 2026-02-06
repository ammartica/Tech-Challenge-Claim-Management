import { useEffect, useState } from "react";
import { Table, Button, Space, Card, Typography, Tag } from "antd";
import { apiGet } from "../api";

const Claims = ({ onGoImport }) => {
  const [rows, setRows] = useState([]);
  const [loading, setLoading] = useState(true);

  const loadClaims = async () => {
    setLoading(true);
    try {
      const res = await apiGet("/claims");
      const data = await res.json();
      setRows(data);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadClaims();
  }, []);

  const logout = () => {
    localStorage.removeItem("token");
    window.location.reload();
  };

  const exportCsv = async () => {
    const res = await apiGet("/claims/export");
    const blob = await res.blob();

    const url = window.URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = "claims_export.csv";
    document.body.appendChild(a);
    a.click();
    a.remove();
    window.URL.revokeObjectURL(url);
  };

  const columns = [
    {
      title: "Claim #",
      dataIndex: "claim_number",
      sorter: (a, b) =>
        (a.claim_number || "").localeCompare(b.claim_number || ""),
    },
    {
      title: "Service Date",
      dataIndex: "service_date",
      sorter: (a, b) =>
        (a.service_date || "").localeCompare(b.service_date || ""),
    },
    {
      title: "Amount",
      dataIndex: "amount",
      sorter: (a, b) => Number(a.amount || 0) - Number(b.amount || 0),
    },
    {
      title: "Status",
      dataIndex: "status",
      render: (status) => {
        const colors = {
          pending: "gold",
          submitted: "blue",
          denied: "red",
          paid: "green",
        };
        return <Tag color={colors[status] || "default"}>{status}</Tag>;
      },
      sorter: (a, b) => (a.status || "").localeCompare(b.status || ""),
    },
  ];

  return (
    <div style={{ padding: 24 }}>
      <Typography.Title level={3}>Claims</Typography.Title>

      <Card>
        <Space style={{ marginBottom: 16 }}>
          <Button onClick={loadClaims}>Refresh</Button>
          <Button type="primary" onClick={exportCsv}>
            Export CSV
          </Button>
          <Button onClick={onGoImport}>Import CSV</Button>
          <Button danger onClick={logout}>
            Logout
          </Button>
        </Space>

        <Table
          rowKey="id"
          loading={loading}
          columns={columns}
          dataSource={rows}
          pagination={{ pageSize: 10 }}
        />
      </Card>
    </div>
  );
};

export default Claims;
