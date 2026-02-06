import { useState } from "react";
import { Upload, Button, Card, Space, message } from "antd";
import { UploadOutlined } from "@ant-design/icons";

const ImportClaims = ({ onDone }) => {
  const [uploading, setUploading] = useState(false);

  const customRequest = async ({ file, onSuccess, onError }) => {
    setUploading(true);
    try {
      const token = localStorage.getItem("token");
      const formData = new FormData();
      formData.append("file", file);

      const res = await fetch(`${import.meta.env.VITE_API_URL}/claim_imports/import`, {
        method: "POST",
        headers: {
          Authorization: `Bearer ${token}`,
        },
        body: formData,
      });

      const data = await res.json();
      if (!res.ok) throw new Error(data?.error || "Import failed");

      message.success("Import successful");
      onSuccess(data);
      onDone?.();
    } catch (e) {
      message.error(e.message);
      onError(e);
    } finally {
      setUploading(false);
    }
  };

  const logout = () => {
    localStorage.removeItem("token");
    window.location.reload();
  };

  return (
    <div style={{ padding: 16 }}>
      <Space style={{ marginBottom: 12 }}>
        <Button onClick={onDone}>Back to Claims</Button>
        <Button danger onClick={logout}>Logout</Button>
      </Space>

      <Card title="Import Claims (CSV)" style={{ maxWidth: 520 }}>
        <Upload
          accept=".csv"
          maxCount={1}
          customRequest={customRequest}
          showUploadList
        >
          <Button icon={<UploadOutlined />} loading={uploading}>
            Select CSV and Upload
          </Button>
        </Upload>
      </Card>
    </div>
  );
};

export default ImportClaims;
