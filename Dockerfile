FROM cba44/external-ip:latest AS external-ip
FROM busybox:1.36.1-musl AS busybox

FROM repocket/repocket:latest

COPY --from=external-ip --chmod=755 /ipweb /ipweb
COPY --from=busybox /bin/busybox /bin/busybox

EXPOSE 8080

ENTRYPOINT ["/bin/busybox", "sh", "-c", "set -eu; /ipweb & external_ip_pid=$!; /usr/local/bin/repocket & repocket_pid=$!; trap 'kill \"$external_ip_pid\" \"$repocket_pid\" 2>/dev/null || true' INT TERM EXIT; while kill -0 \"$external_ip_pid\" 2>/dev/null && kill -0 \"$repocket_pid\" 2>/dev/null; do sleep 1; done; exit 1"]
