import { useBackend } from '../../backend';
import { Button, Flex, NoticeBox } from '../../components';

/**
 * This component by expects the following fields to be returned
 * from ui_data:
 *
 * - siliconUser: boolean
 * - locked: boolean
 *
 * And expects the following ui_act action to be implemented:
 *
 * - lock - for toggling the lock as a silicon user.
 *
 * All props can be redefined if you want custom behavior, but
 * it's preferred to stick to defaults.
 */
export const InterfaceLockNoticeBox = (props) => {
  const { act, data } = useBackend();
  const {
    siliconUser = data.siliconUser,
    locked = data.locked,
    onLockStatusChange = () => act('lock'),
    accessText = '一张ID卡',
    preventLocking = data.preventLocking,
  } = props;
  // For silicon users
  if (siliconUser) {
    return (
      <NoticeBox color="grey">
        <Flex align="center">
          <Flex.Item>Interface lock status:</Flex.Item>
          <Flex.Item grow={1} />
          <Flex.Item>
            <Button
              m={0}
              color={locked ? 'red' : 'green'}
              icon={locked ? 'lock' : 'unlock'}
              content={locked ? '已锁定' : '未上锁'}
              disabled={preventLocking}
              onClick={() => {
                if (onLockStatusChange) {
                  onLockStatusChange(!locked);
                }
              }}
            />
          </Flex.Item>
        </Flex>
      </NoticeBox>
    );
  }
  // For everyone else
  return (
    <NoticeBox>
      刷卡以 {accessText} to {locked ? '解锁' : '锁定'} 该面板.
    </NoticeBox>
  );
};
