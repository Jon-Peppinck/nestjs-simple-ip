import { Injectable } from '@nestjs/common';
import * as os from 'os';

@Injectable()
export class AppService {
  getHello(): string {
    return 'Hello World!';
  }

  getPrivateIpOrHostname(): string {
    // Get the private IP address or hostname of the current EC2 instance
    const networkInterfaces = os.networkInterfaces();
    const interfaceKeys = Object.keys(networkInterfaces);

    for (const ifaceKey of interfaceKeys) {
      const iface = networkInterfaces[ifaceKey];
      for (const entry of iface) {
        // Check for private IPv4 address (skip loopback and non-IPv4 addresses)
        if (!entry.internal && entry.family === 'IPv4') {
          return entry.address; // Return private IP address
        }
      }
    }

    // If private IP is not found, return hostname
    return os.hostname();
  }
}
