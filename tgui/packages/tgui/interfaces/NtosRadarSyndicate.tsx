import { NtosWindow } from '../layouts';
import { NtosRadarContent } from './NtosRadar';

export const NtosRadarSyndicate = () => {
  return (
    <NtosWindow width={800} height={600} theme="syndicate">
      <NtosRadarContent sig_err={'超出范围'} />
    </NtosWindow>
  );
};
