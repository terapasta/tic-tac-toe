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
  }
])
