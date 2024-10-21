export const CRIMESTATUS2COLOR = {
  Arrest: 'bad',
  Discharged: 'blue',
  Incarcerated: 'average',
  Parole: 'good',
  Suspected: 'teal',
} as const;

export const CRIMESTATUS2DESC = {
  Arrest: '逮捕. 必须先设置这个人的罪名才能设置此状态.',
  Discharged: '释放. 这个人经审判被判无罪.',
  Incarcerated: '关押. 这个人目前正在服刑.',
  Parole: '假释. 获释出狱，但仍在监管之下.',
  Suspected: '涉嫌. 需要密切监视这个人的活动.',
} as const;
