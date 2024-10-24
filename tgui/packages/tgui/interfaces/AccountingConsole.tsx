import { BooleanLike } from 'common/react';
import { useState } from 'react';
import {
  BlockQuote,
  Collapsible,
  Modal,
  Section,
  Stack,
  Tabs,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Data = {
  PlayerAccounts: PlayerAccount[];
  AuditLog: AuditLog[];
  Crashing: BooleanLike;
};

type PlayerAccount = {
  index: number;
  name: string;
  balance: number;
  job: string;
  modifier: number;
};

type AuditLog = {
  index: number;
  account: number;
  cost: number;
  vendor: string;
};

enum SCREENS {
  users,
  audit,
}

export const AccountingConsole = (props) => {
  const [screenmode, setScreenmode] = useState(SCREENS.users);

  return (
    <Window width={300} height={360}>
      <Window.Content>
        <Stack fill vertical>
          <MarketCrashing />
          <Stack.Item>
            <Tabs fluid textAlign="center">
              <Tabs.Tab
                selected={screenmode === SCREENS.users}
                onClick={() => setScreenmode(SCREENS.users)}
              >
                用户
              </Tabs.Tab>
              <Tabs.Tab
                selected={screenmode === SCREENS.audit}
                onClick={() => setScreenmode(SCREENS.audit)}
              >
                审计
              </Tabs.Tab>
            </Tabs>
          </Stack.Item>
          <Stack.Item grow>
            {screenmode === SCREENS.users && <UsersScreen />}
            {screenmode === SCREENS.audit && <AuditScreen />}
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const UsersScreen = (props) => {
  const { data } = useBackend<Data>();
  const { PlayerAccounts } = data;

  return (
    <Section fill scrollable title="船员账户汇总">
      {PlayerAccounts.map((account) => (
        <Collapsible key={account.index} title={account.name + account.job}>
          <Stack vertical>
            <BlockQuote>
              <Stack.Item textColor={'green'}>
                {account.balance} 信用点余额
              </Stack.Item>
              <Stack.Item>
                员工薪酬调整系数为{account.modifier * 100}%
              </Stack.Item>
            </BlockQuote>
          </Stack>
        </Collapsible>
      ))}
    </Section>
  );
};

const AuditScreen = (props) => {
  const { data } = useBackend<Data>();
  const { AuditLog } = data;

  return (
    <Section fill scrollable>
      {AuditLog.map((purchase) => (
        <BlockQuote key={purchase.index} p={1}>
          <b>{purchase.account}</b>花费<b>{purchase.cost}</b> cr 于{' '}
          <i>{purchase.vendor}.</i>
        </BlockQuote>
      ))}
    </Section>
  );
};

/** The modal menu that contains the prompts to making new channels. */
const MarketCrashing = (props) => {
  const { data } = useBackend<Data>();

  const { Crashing } = data;
  if (!Crashing) {
    return null;
  }
  return (
    <Modal textAlign="center" mr={1.5}>
      <blink>老天爷啊经济崩溃了.</blink>
    </Modal>
  );
};
