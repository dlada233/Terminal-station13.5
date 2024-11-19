import { useBackend } from '../backend';
import { NoticeBox } from '../components';
import { NtosWindow } from '../layouts';
import { MODsuitContent } from './MODsuit';

export const NtosMODsuit = (props) => {
  const { data } = useBackend();
  const { ui_theme } = data;
  return (
    <NtosWindow theme={ui_theme}>
      <NtosWindow.Content scrollable>
        <NtosMODsuitContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};

const NtosMODsuitContent = (props) => {
  const { data } = useBackend();
  const { has_suit } = data;
  if (!has_suit) {
    return (
      <NoticeBox mt={1} mb={0} danger fontSize="12px">
        没有模块服连接，请在应用主机上使用模块服进行同步
      </NoticeBox>
    );
  } else {
    return <MODsuitContent />;
  }
};
