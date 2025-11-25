import { Controller, Get, Post, Body, Param } from '@nestjs/common';
import { S3Service } from './s3.service';

@Controller()
export class AppController {
  constructor(private readonly s3: S3Service) {}

  // POST /presign/upload  { "key": "user123/file.png" }
  @Post('presign/upload')
  async presignUpload(@Body() body: { key: string }) {
    if (!body?.key) return { error: 'key required' };
    const url = await this.s3.presignUpload(body.key);
    return { url, key: body.key };
  }

  // GET /presign/download/:key  (key needs URL encoding)
  @Get('presign/download/:key')
  async presignDownload(@Param('key') key: string) {
    const decoded = decodeURIComponent(key);
    const url = await this.s3.presignDownload(decoded);
    return { url, key: decoded };
  }
}
