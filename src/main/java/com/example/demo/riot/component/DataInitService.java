package com.example.demo.riot.component;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.example.demo.riot.mapper.ChampionInfoMapper;
import com.example.demo.riot.mapper.ChampionRotationMapper;
import com.example.demo.riot.mapper.ChampionSpellMapper;
import com.example.demo.riot.mapper.RuneInfoMapper;
import com.example.demo.riot.mapper.SummonerSpellMapper;
import com.example.demo.riot.vo.ChampRotationVO;
import com.example.demo.riot.vo.ChampionInfoVO;
import com.example.demo.riot.vo.ChampionSpellVO;
import com.example.demo.riot.vo.RuneInfoVO;
import com.example.demo.riot.vo.SummonerSpellVO;
import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.extern.slf4j.Slf4j;

@Component
@Slf4j
public class DataInitService {

	private static final String VERSIONS_URL = "https://ddragon.leagueoflegends.com/api/versions.json";
	private static final String CHAMPION_URL = "https://ddragon.leagueoflegends.com/cdn/%s/data/ko_KR/champion.json";
	private static final String CHAMPION_DETAIL_URL = "https://ddragon.leagueoflegends.com/cdn/%s/data/ko_KR/champion/%s.json";
	private static final String SUMMONER_SPELL_URL = "https://ddragon.leagueoflegends.com/cdn/%s/data/ko_KR/summoner.json";
	private static final String RUNES_URL = "https://ddragon.leagueoflegends.com/cdn/%s/data/ko_KR/runesReforged.json";
	private static final String ROTATION_URL = "https://kr.api.riotgames.com/lol/platform/v3/champion-rotations";

	@Autowired
	private RiotData riotData;

	@Resource
	private ChampionInfoMapper championInfoMapper;
	@Resource
	private ChampionSpellMapper championSpellMapper;
	@Resource
	private SummonerSpellMapper summonerSpellMapper;
	@Resource
	private RuneInfoMapper runeInfoMapper;
	@Resource
	private ChampionRotationMapper championRotationMapper;

	private final ObjectMapper om = new ObjectMapper();

	/**
	 * 최신 DDragon 버전 조회
	 */
	public String getLatestVersion() throws IOException {
		String response = riotData.getStaticReadData(VERSIONS_URL);
		if (response == null) throw new IOException("DDragon 버전 조회 실패");
		List<String> versions = om.readValue(response, List.class);
		return versions.get(0);
	}

	/**
	 * 전체 초기 데이터 세팅 (champion_info + champion_spell + summoner_spell + rune_info)
	 */
	public Map<String, Object> initAllData() {
		Map<String, Object> result = new HashMap<>();
		try {
			String version = getLatestVersion();
			log.info("=== 초기 데이터 세팅 시작 (DDragon v{}) ===", version);
			result.put("version", version);

			result.put("championInfo", syncChampionInfo(version));
			result.put("summonerSpell", syncSummonerSpell(version));
			result.put("runeInfo", syncRuneInfo(version));
			result.put("rotation", fetchAndUpdateRotation(version));
			result.put("championSpell", syncChampionSpell(version));


			result.put("success", true);
			log.info("=== 초기 데이터 세팅 완료 ===");
		} catch (Exception e) {
			log.error("초기 데이터 세팅 실패", e);
			result.put("success", false);
			result.put("error", e.getMessage());
		}
		return result;
	}

	/**
	 * champion_info 동기화
	 */
	public int syncChampionInfo(String version) throws IOException {
		String url = String.format(CHAMPION_URL, version);
		String response = riotData.getStaticReadData(url);
		if (response == null) throw new IOException("챔피언 데이터 조회 실패");

		Map<String, Object> root = om.readValue(response, Map.class);
		Map<String, Object> data = (Map<String, Object>) root.get("data");

		int count = 0;
		for (Map.Entry<String, Object> entry : data.entrySet()) {
			Map<String, Object> champData = (Map<String, Object>) entry.getValue();
			ChampionInfoVO champ = new ChampionInfoVO();
			champ.setChampionInfoId(champData.get("id").toString());
			champ.setChampionInfoName(champData.get("name").toString());
			champ.setChampionInfoKey(Integer.parseInt(champData.get("key").toString()));
			championInfoMapper.upsertChampionInfo(champ);
			count++;
		}
		log.info("champion_info 동기화: {}건", count);
		return count;
	}
	/**
	 * 로테이션 동기화
	 */
	public int fetchAndUpdateRotation(String version) {
		try {
			String url = String.format(ROTATION_URL, version);
			String response = riotData.getReadData(url);
			if (response == null) throw new IOException("로테이션 API 응답 없음");

			ChampRotationVO rc = om.readValue(response, ChampRotationVO.class);
			List<Integer> rotationList = rc.getFreeChampionIds();
			log.info("로테이션 챔피언 목록: {}", rotationList);

			if (rotationList == null || rotationList.isEmpty()) {
				log.warn("로테이션 챔피언 목록이 비어있음");
				return 0;
			}

			championRotationMapper.deleteChampionRotation();
			int result = 0;
			for (int championInfoKey : rotationList) {
				result += championRotationMapper.insertChampionRotation(championInfoKey);
			}

			log.info("로테이션 갱신 완료: {}개 챔피언", result);
			return result;
		} catch (IOException e) {
			log.error("로테이션 갱신 실패", e);
			return -1;
		}
	}
	/**
	 * summoner_spell 동기화
	 */
	public int syncSummonerSpell(String version) throws IOException {
		String url = String.format(SUMMONER_SPELL_URL, version);
		String response = riotData.getStaticReadData(url);
		if (response == null) throw new IOException("소환사 주문 데이터 조회 실패");

		Map<String, Object> root = om.readValue(response, Map.class);
		Map<String, Object> data = (Map<String, Object>) root.get("data");

		int count = 0;
		for (Map.Entry<String, Object> entry : data.entrySet()) {
			Map<String, Object> spellData = (Map<String, Object>) entry.getValue();
			SummonerSpellVO spell = new SummonerSpellVO();
			spell.setSummonerSpellId(spellData.get("id").toString());
			spell.setSummonerSpellName(spellData.get("name").toString());
			spell.setSummonerSpellDesc(spellData.get("description").toString());
			spell.setSummonerSpellKey(Integer.parseInt(spellData.get("key").toString()));
			summonerSpellMapper.insertSummonerSpell(spell);
			count++;
		}
		log.info("summoner_spell 동기화: {}건", count);
		return count;
	}

	/**
	 * rune_info 동기화 (스타일 + 개별 룬 모두 저장)
	 */
	public int syncRuneInfo(String version) throws IOException {
		String url = String.format(RUNES_URL, version);
		String response = riotData.getStaticReadData(url);
		if (response == null) throw new IOException("룬 데이터 조회 실패");

		List<Map<String, Object>> styles = om.readValue(response, List.class);

		int count = 0;
		for (Map<String, Object> style : styles) {
			// 룬 스타일 (지배, 정밀, 마법 등) 저장
			RuneInfoVO styleRune = new RuneInfoVO();
			styleRune.setRuneId((int) style.get("id"));
			styleRune.setRuneKey(style.get("key").toString());
			styleRune.setRuneName(style.get("name").toString());
			styleRune.setRuneImgPath(style.get("icon").toString());
			styleRune.setRuneDesc("");
			runeInfoMapper.insertRuneInfo(styleRune);
			count++;

			// 각 슬롯의 개별 룬 저장
			List<Map<String, Object>> slots = (List<Map<String, Object>>) style.get("slots");
			for (Map<String, Object> slot : slots) {
				List<Map<String, Object>> runes = (List<Map<String, Object>>) slot.get("runes");
				for (Map<String, Object> rune : runes) {
					RuneInfoVO runeInfo = new RuneInfoVO();
					runeInfo.setRuneId((int) rune.get("id"));
					runeInfo.setRuneKey(rune.get("key").toString());
					runeInfo.setRuneName(rune.get("name").toString());
					runeInfo.setRuneImgPath(rune.get("icon").toString());
					runeInfo.setRuneDesc(rune.get("shortDesc").toString());
					runeInfoMapper.insertRuneInfo(runeInfo);
					count++;
				}
			}
		}
		log.info("rune_info 동기화: {}건", count);
		return count;
	}

	/**
	 * champion_spell 동기화 (각 챔피언의 Q/W/E/R/패시브)
	 */
	public int syncChampionSpell(String version) throws IOException {
		// 챔피언 목록 조회
		String listUrl = String.format(CHAMPION_URL, version);
		String listResponse = riotData.getStaticReadData(listUrl);
		if (listResponse == null) throw new IOException("챔피언 목록 조회 실패");

		Map<String, Object> root = om.readValue(listResponse, Map.class);
		Map<String, Object> data = (Map<String, Object>) root.get("data");

		// 기존 스펠 전체 삭제
		championSpellMapper.deleteAllChampionSpell();
		log.info("champion_spell 기존 데이터 삭제 완료");

		int totalCount = 0;
		int champCount = 0;
		for (Map.Entry<String, Object> entry : data.entrySet()) {
			String champId = entry.getKey();
			Map<String, Object> champBasic = (Map<String, Object>) entry.getValue();
			int champKey = Integer.parseInt(champBasic.get("key").toString());

			try {
				// 챔피언 상세 데이터 조회
				String detailUrl = String.format(CHAMPION_DETAIL_URL, version, champId);
				String detailResponse = riotData.getStaticReadData(detailUrl);
				if (detailResponse == null) {
					log.warn("챔피언 상세 조회 실패: {}", champId);
					continue;
				}

				Map<String, Object> detailRoot = om.readValue(detailResponse, Map.class);
				Map<String, Object> detailData = (Map<String, Object>) detailRoot.get("data");
				Map<String, Object> champDetail = (Map<String, Object>) detailData.get(champId);

				// Q, W, E, R 스펠
				List<Map<String, Object>> spells = (List<Map<String, Object>>) champDetail.get("spells");
				char[] spellTypes = {'Q', 'W', 'E', 'R'};
				for (int i = 0; i < spells.size() && i < 4; i++) {
					Map<String, Object> spell = spells.get(i);
					ChampionSpellVO csv = new ChampionSpellVO();
					csv.setChampionInfoKey(champKey);
					csv.setChampionSpellId(spell.get("id").toString());
					csv.setChampionSpellName(spell.get("name").toString());
					csv.setChampionSpellDescription(spell.get("description").toString());
					csv.setChampionSpellCooldown(spell.get("cooldownBurn").toString());
					csv.setChampionSpellCost(spell.get("costBurn").toString());
					csv.setChampionSpellRange(spell.get("rangeBurn").toString());
					csv.setChampionSpellType(spellTypes[i]);
					championSpellMapper.insertChampionSpell(csv);
					totalCount++;
				}

				// 패시브
				Map<String, Object> passive = (Map<String, Object>) champDetail.get("passive");
				if (passive != null) {
					ChampionSpellVO passiveVo = new ChampionSpellVO();
					passiveVo.setChampionInfoKey(champKey);
					Map<String, Object> passiveImage = (Map<String, Object>) passive.get("image");
					passiveVo.setChampionSpellId(passiveImage.get("full").toString());
					passiveVo.setChampionSpellName(passive.get("name").toString());
					passiveVo.setChampionSpellDescription(passive.get("description").toString());
					passiveVo.setChampionSpellType('P');
					championSpellMapper.insertChampionSpell(passiveVo);
					totalCount++;
				}

				champCount++;
				if (champCount % 20 == 0) {
					log.info("champion_spell 진행: {}/{}", champCount, data.size());
				}
			} catch (Exception e) {
				log.error("챔피언 스펠 동기화 실패: {}", champId, e);
			}
		}
		log.info("champion_spell 동기화: {}개 챔피언, {}건 스펠", champCount, totalCount);
		return totalCount;
	}
}
