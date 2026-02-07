import { useState } from "react";
import { Upload, Button, Card, Space, Typography, message } from "antd";
import { UploadOutlined } from "@ant-design/icons";

const ImportClaims = ({ onDone }) => {
  const [uploading, setUploading] = useState(false);

  const customRequest = async ({ file, onSuccess, onError }) => {
    setUploading(true);
    try {
      const token = localStorage.getItem("token");
      const formData = new FormData();
      formData.append("file", file);

      const res = await fetch(
        `${import.meta.env.VITE_API_URL}/claim_imports/import`,
        {
          method: "POST",
          headers: {
            Authorization: `Bearer ${token}`,
          },
          body: formData,
        },
      );

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

  return (
    <div style={{ padding: 24 }}>
      <Typography.Title level={2}>Import Claims</Typography.Title>

      <Card style={{ maxWidth: 520 }}>
        <Typography.Paragraph type="secondary">
          Upload a CSV file containing medical claims. Invalid rows will be
          skipped.
        </Typography.Paragraph>

        <Upload
          accept=".csv"
          maxCount={1}
          customRequest={customRequest}
          showUploadList
          disabled={uploading}
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
