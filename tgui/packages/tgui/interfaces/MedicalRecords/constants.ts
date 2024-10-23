export const PHYSICALSTATUS2ICON = {
  Active: 'person-running',
  Debilitated: 'crutch',
  Unconscious: 'moon-o',
  Deceased: 'skull',
};

export const PHYSICALSTATUS2COLOR = {
  Active: 'green',
  Debilitated: 'purple',
  Unconscious: 'orange',
  Deceased: 'red',
} as const;

export const PHYSICALSTATUS2DESC = {
  Active: '正常, 身体健康且意识清醒.',
  Debilitated: '虚弱. 意识清醒但身体抱恙.',
  Unconscious: '无意识. 可能需要医疗照顾.',
  Deceased: '已故. 已经死亡并开始腐烂.',
} as const;

export const MENTALSTATUS2ICON = {
  Stable: 'face-smile-o',
  Watch: 'eye-o',
  Unstable: 'scale-unbalanced-flip',
  Insane: 'head-side-virus',
};

export const MENTALSTATUS2COLOR = {
  Stable: 'green',
  Watch: 'purple',
  Unstable: 'orange',
  Insane: 'red',
} as const;

export const MENTALSTATUS2DESC = {
  Stable: '稳定，心智健全，无心理问题.',
  Watch: '关注. 有精神疾病症状，需要密切关注.',
  Unstable: '不稳定. 有一种或多种精神疾病.',
  Insane: '疯狂. 表现出严重的异常行为.',
} as const;
