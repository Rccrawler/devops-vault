import { Injectable } from '@nestjs/common';
import { S3Client, PutObjectCommand, GetObjectCommand } from '@aws-sdk/client-s3';
import { getSignedUrl } from '@aws-sdk/s3-request-presigner';
import * as process from 'process';

@Injectable()
export class S3Service {
  private s3: S3Client;
  private bucket: string;

  constructor() {
    const endpoint = process.env.MINIO_ENDPOINT || 'http://localhost:9000';
    this.bucket = process.env.BUCKET || 'uploads';
    this.s3 = new S3Client({
      endpoint,
      region: process.env.MINIO_REGION || 'us-east-1',
      credentials: {
        accessKeyId: process.env.MINIO_ACCESS_KEY || 'minio',
        secretAccessKey: process.env.MINIO_SECRET_KEY || 'minio123',
      },
      forcePathStyle: true,
    } as any);
  }

  async presignUpload(key: string, expiresSeconds = 600) {
    const cmd = new PutObjectCommand({
      Bucket: this.bucket,
      Key: key,
    });
    return await getSignedUrl(this.s3, cmd, { expiresIn: expiresSeconds });
  }

  // devuelve URL pública (presigned) para descargar
  async presignDownload(key: string, expiresSeconds = 600) {
    const cmd = new GetObjectCommand({
      Bucket: this.bucket,
      Key: key,
    });
    return await getSignedUrl(this.s3, cmd, { expiresIn: expiresSeconds });
  }
}
