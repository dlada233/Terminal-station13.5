// THIS IS A SKYRAT UI FILE
import { useBackend, useLocalState } from '../backend';
import {
  Box,
  Button,
  Divider,
  Image,
  NoticeBox,
  Section,
  Stack,
} from '../components';
import { Window } from '../layouts';

export const ArmamentStation = (props) => {
  const [category, setCategory] = useLocalState('category', '');
  const [weapon, setArmament] = useLocalState('weapon');
  const { act, data } = useBackend();
  const { armaments_list = [], card_inserted, card_points, card_name } = data;
  return (
    <Window theme="armament" title="武器站" width={1000} height={600}>
      <Window.Content>
        <Section grow height="100%" title="武器站">
          {card_inserted ? (
            <Stack>
              <Stack.Item grow fill>
                <Box>
                  <b>已插入的兑换卡:</b> {card_name}
                </Box>
                <Box>
                  <b>剩余点数:</b> {card_points}
                </Box>
              </Stack.Item>
              <Stack.Item>
                <Button
                  icon="eject"
                  fontSize="20px"
                  content="取出兑换卡"
                  onClick={() => act('eject_card')}
                />
              </Stack.Item>
            </Stack>
          ) : (
            <NoticeBox color="bad">未插入兑换卡.</NoticeBox>
          )}
          <Divider />
          <Stack fill grow>
            <Stack.Item mr={1}>
              <Section title="类别">
                <Stack vertical>
                  {armaments_list.map((armament_category) => (
                    <Stack.Item key={armament_category.category}>
                      <Button
                        width="100%"
                        content={
                          armament_category.category +
                          ' (上限 ' +
                          armament_category.category_limit +
                          ')'
                        }
                        selected={category === armament_category.category}
                        onClick={() => setCategory(armament_category.category)}
                      />
                    </Stack.Item>
                  ))}
                </Stack>
              </Section>
            </Stack.Item>
            <Divider vertical />
            <Stack.Item grow mr={1}>
              <Section title={category} scrollable fill height="480px">
                {armaments_list.map(
                  (armament_category) =>
                    armament_category.category === category &&
                    armament_category.subcategories.map((subcat) => (
                      <Section
                        key={subcat.subcategory}
                        title={subcat.subcategory}
                      >
                        <Stack vertical>
                          {subcat.items.map((item) => (
                            <Stack.Item key={item.ref}>
                              <Button
                                fontSize="15px"
                                textAlign="center"
                                selected={weapon === item.ref}
                                color={
                                  item.purchased >= item.quantity
                                    ? 'bad'
                                    : 'default'
                                }
                                width="100%"
                                key={item.ref}
                                onClick={() => setArmament(item.ref)}
                              >
                                <img
                                  src={`data:image/jpeg;base64,${item.icon}`}
                                  style={{
                                    verticalAlign: 'middle',
                                    textAlign: 'center',
                                  }}
                                />
                                &nbsp;{item.name}
                              </Button>
                            </Stack.Item>
                          ))}
                        </Stack>
                      </Section>
                    )),
                )}
              </Section>
            </Stack.Item>
            <Divider vertical />
            <Stack.Item width="20%">
              <Section title="已选择武器">
                {armaments_list.map((armament_category) =>
                  armament_category.subcategories.map((subcat) =>
                    subcat.items.map(
                      (item) =>
                        item.ref === weapon && (
                          <Stack vertical key={item.ref}>
                            <Stack.Item>
                              <Image
                                src={`data:image/jpeg;base64,${item.icon}`}
                                height={'100%'}
                                width={'100%'}
                                style={{
                                  verticalAlign: 'middle',
                                  horizontalAlign: 'middle',
                                }}
                              />
                            </Stack.Item>
                            <Stack.Item>{item.description}</Stack.Item>
                            <Stack.Item
                              textColor={
                                item.quantity - item.purchased <= 0
                                  ? 'red'
                                  : 'green'
                              }
                            >
                              {'剩余数量: ' + (item.quantity - item.purchased)}
                            </Stack.Item>
                            <Stack.Item
                              textColor={
                                item.cost > card_points || !card_inserted
                                  ? 'red'
                                  : 'green'
                              }
                            >
                              {'花费: ' + item.cost}
                            </Stack.Item>
                            {!!item.buyable_ammo && (
                              <Stack.Item
                                textColor={
                                  item.magazine_cost > card_points ||
                                  !card_inserted
                                    ? 'red'
                                    : 'green'
                                }
                              >
                                {'弹药花费: ' + item.magazine_cost}
                              </Stack.Item>
                            )}
                            <Stack.Item>
                              <Button
                                content="购买"
                                textAlign="center"
                                width="100%"
                                disabled={
                                  item.cost > card_points ||
                                  item.purchased >= item.quantity
                                }
                                onClick={() =>
                                  act('equip_item', {
                                    armament_ref: item.ref,
                                  })
                                }
                              />
                            </Stack.Item>
                            {!!item.buyable_ammo && (
                              <Stack.Item>
                                <Button
                                  content="购买弹药"
                                  textAlign="center"
                                  width="100%"
                                  disabled={item.magazine_cost > card_points}
                                  onClick={() =>
                                    act('buy_ammo', {
                                      armament_ref: item.ref,
                                    })
                                  }
                                />
                              </Stack.Item>
                            )}
                          </Stack>
                        ),
                    ),
                  ),
                )}
              </Section>
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
