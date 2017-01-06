User.seed(:id, [
  {
    id: 1,
    email: 'hoge@example.com',
    password: 'hogehoge',
    role: :normal,
  },
  {
    id: 2,
    email: 'worker@example.com',
    password: 'samplepass',
    role: :worker,
  },
  {
    id: 3,
    email: 'worker2@example.com',
    password: 'samplepass',
    role: :worker,
  }
])
