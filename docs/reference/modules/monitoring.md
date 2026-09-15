# Module: monitoring
 The Log Analytics workspace that Container Apps actually uses today is
created inline in [`modules/container_app`](container_app.md) instead. This is a known
inconsistency, not an intentional design — the workspace should move here once this
module is built out, so monitoring resources (workspace, diagnostic settings, alerts)
have one home instead of being scattered across modules that need them incidentally.
