const baseUrl = process.env.API_BASE_URL ?? 'http://127.0.0.1:3000';
const totalRequests = Number(process.env.STRESS_TOTAL ?? 1000);
const concurrency = Number(process.env.STRESS_CONCURRENCY ?? 50);

const scenarios = [
  {
    name: 'health',
    method: 'GET',
    path: '/health',
  },
  {
    name: 'tile-calculate',
    method: 'POST',
    path: '/api/tiles/calculate',
    body: {
      floorLength: 4,
      floorWidth: 4,
      tileLength: 20,
      tileWidth: 20,
      tilesPerBox: 10,
      wastePercentage: 10,
    },
  },
];

const sortNumbers = (values) => values.toSorted((a, b) => a - b);

const percentile = (values, percent) => {
  if (values.length === 0) return 0;
  const sorted = sortNumbers(values);
  const index = Math.min(
    sorted.length - 1,
    Math.ceil((percent / 100) * sorted.length) - 1,
  );
  return sorted[index];
};

const runRequest = async (scenario) => {
  const startedAt = performance.now();
  const response = await fetch(`${baseUrl}${scenario.path}`, {
    method: scenario.method,
    headers: scenario.body ? { 'Content-Type': 'application/json' } : undefined,
    body: scenario.body ? JSON.stringify(scenario.body) : undefined,
  });
  await response.arrayBuffer();

  return {
    statusCode: response.status,
    durationMs: performance.now() - startedAt,
  };
};

const runScenario = async (scenario) => {
  let started = 0;
  let completed = 0;
  let failed = 0;
  const durations = [];
  const startedAt = performance.now();

  const worker = async () => {
    while (started < totalRequests) {
      started += 1;

      try {
        const result = await runRequest(scenario);
        durations.push(result.durationMs);
        if (result.statusCode < 200 || result.statusCode >= 300) {
          failed += 1;
        } else {
          completed += 1;
        }
      } catch {
        failed += 1;
      }
    }
  };

  await Promise.all(
    Array.from({ length: concurrency }, async () => {
      await worker();
    }),
  );

  const totalDurationSeconds = (performance.now() - startedAt) / 1000;

  return {
    scenario: scenario.name,
    totalRequests,
    successful: completed,
    failed,
    requestsPerSecond: Number((totalRequests / totalDurationSeconds).toFixed(2)),
    averageMs: Number(
      (durations.reduce((sum, value) => sum + value, 0) / durations.length).toFixed(2),
    ),
    p50Ms: Number(percentile(durations, 50).toFixed(2)),
    p95Ms: Number(percentile(durations, 95).toFixed(2)),
    p99Ms: Number(percentile(durations, 99).toFixed(2)),
  };
};

const results = [];
for (const scenario of scenarios) {
  results.push(await runScenario(scenario));
}

console.table(results);

if (results.some((result) => result.failed > 0)) {
  process.exitCode = 1;
}
