export const environment = {
  production: false,
  apiUrl: (window as any).__env?.apiUrl || 'http://localhost:8081/v1'
};
