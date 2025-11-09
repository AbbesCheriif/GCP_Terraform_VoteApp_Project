import { bootstrapApplication } from '@angular/platform-browser';
import { AppComponent } from './app/app.component';
import { config } from './app/app.config.server';

// The SSR engine will call this exported function with a BootstrapContext.
// Forward that `context` to `bootstrapApplication` so the server platform
// is properly initialized and the NG0401 error is avoided.
const bootstrap = (context: unknown) => bootstrapApplication(AppComponent, config, context as any);

export default bootstrap;
