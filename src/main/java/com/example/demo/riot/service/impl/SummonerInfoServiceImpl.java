package com.example.demo.riot.service.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.community.vo.PageVO;
import com.example.demo.riot.component.ParseMatchGame;
import com.example.demo.riot.component.RiotData;
import com.example.demo.riot.mapper.ChampionInfoMapper;
import com.example.demo.riot.mapper.MatchGameInfoMapper;
import com.example.demo.riot.mapper.MatchItemSlotMapper;
import com.example.demo.riot.mapper.RuneInfoMapper;
import com.example.demo.riot.mapper.RunePageMapper;
import com.example.demo.riot.mapper.SummonerInfoMapper;
import com.example.demo.riot.mapper.SummonerSpellMapper;
import com.example.demo.riot.service.SummonerInfoService;
import com.example.demo.riot.utill.GameTime;
import com.example.demo.riot.vo.ChampionInfoVO;
import com.example.demo.riot.vo.MatchGameInfoVO;
import com.example.demo.riot.vo.MatchItemSlotVO;
import com.example.demo.riot.vo.RunePageVO;
import com.example.demo.riot.vo.SummonerInfoVO;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class SummonerInfoServiceImpl implements SummonerInfoService {

	@Resource
	private SummonerInfoMapper sim;
	@Resource
	private MatchGameInfoMapper mim;
	
	@Resource
	private ChampionInfoMapper cim;
	@Resource
	private MatchGameInfoMapper mgim;
	@Resource
	private SummonerSpellMapper ssm;
	@Resource
	private RunePageMapper rpm; // matchGame의 pk rune
	@Resource
	private RuneInfoMapper rim;
	@Resource
	private MatchItemSlotMapper mism;
	
	
	@Autowired
	RiotData rd;
	
	@Autowired
	ParseMatchGame pmg;
	
	public List<Map<String,Object>> matchGameParse(List<MatchGameInfoVO> matchGames,String summonerId) {
		List<Map<String,Object>> rMatchGame = new ArrayList<>();
		for(MatchGameInfoVO matchGame : matchGames) {
			Map<String,Object> summonerInfo = new HashMap<>();
			if(summonerId.equals(matchGame.getSummonerInfoId())) {
				summonerInfo.put("mMatchGame",matchGame);
				MatchItemSlotVO mis = new MatchItemSlotVO();
				mis.setPkMatchItemSlot(matchGame.getPkMatchItemSlot());
				mis= mism.selectMatchItemSlotByKey(mis);
				RunePageVO rpv = new RunePageVO();
				rpv.setPkRunePage(matchGame.getPkRunePage());
				rpv = rpm.selectRunePageByPage(rpv);
				
				summonerInfo.put("mRune1",rim.selectRuneInfo(rpv.getPerk0()));
				summonerInfo.put("mRune2",rim.selectRuneInfo(rpv.getPerkSubStyle()));
				summonerInfo.put("mSpell1",ssm.selectSummonerSpell(matchGame.getMatchGameSpell1()));
				summonerInfo.put("mSpell2",ssm.selectSummonerSpell(matchGame.getMatchGameSpell2()));
				
				GameTime pg = new GameTime();
				summonerInfo.put("betweenTime",pg.betweenTime(matchGame.getMatchGameCreation()));
				summonerInfo.put("playTime",pg.playTime(matchGame.getMatchGameTime()));
				ChampionInfoVO champ = new ChampionInfoVO();
				int championInfoKey = matchGame.getChampionInfoKey();
				champ.setChampionInfoKey(championInfoKey);
				champ = cim.selectChampionInfo(champ);
				
				
				int kills = matchGame.getMatchGameKills();
				double deaths = matchGame.getMatchGameDeaths();
				int assists = matchGame.getMatchGameAssists();
				if(deaths == 0) {
					deaths = 0.9;
				}
				double kda = (kills+assists)*1.0/deaths;
				kda = Math.round(kda*100)/100.0;
				summonerInfo.put("kda",kda);
				
				summonerInfo.put("mMatchGame",matchGame);
				summonerInfo.put("mChamp",champ);
				summonerInfo.put("mItems",mis);
				rMatchGame.add(summonerInfo);
			}else {
				summonerInfo.put("matchGame",matchGame);
				MatchItemSlotVO mis = new MatchItemSlotVO();
				mis.setPkMatchItemSlot(matchGame.getPkMatchItemSlot());
				mis= mism.selectMatchItemSlotByKey(mis);
				
				RunePageVO rpv = new RunePageVO();
				rpv.setPkRunePage(matchGame.getPkRunePage());
				rpv = rpm.selectRunePageByPage(rpv);
				summonerInfo.put("rune1",rim.selectRuneInfo(rpv.getPerk0()));
				summonerInfo.put("rune2",rim.selectRuneInfo(rpv.getPerkSubStyle()));
				summonerInfo.put("spell1",ssm.selectSummonerSpell(matchGame.getMatchGameSpell1()));
				summonerInfo.put("spell2",ssm.selectSummonerSpell(matchGame.getMatchGameSpell2()));
				
				ChampionInfoVO champ = new ChampionInfoVO();
				int championInfoKey = matchGame.getChampionInfoKey();
				champ.setChampionInfoKey(championInfoKey);
				champ = cim.selectChampionInfo(champ);
				
				int kills = matchGame.getMatchGameKills();
				double deaths = matchGame.getMatchGameDeaths();
				int assists = matchGame.getMatchGameAssists();
				if(deaths == 0) {
					deaths = 0.9;
				}
				double kda = (kills+assists)*1.0/deaths;
				kda = Math.round(kda*100)/100.0;
				summonerInfo.put("kda",kda);
				
				summonerInfo.put("matchGame",matchGame);
				summonerInfo.put("champ",champ);
				summonerInfo.put("items",mis);
				rMatchGame.add(summonerInfo);
			}
		}
		return rMatchGame;
	}
	
	public SummonerInfoVO getSummoner(String summoner){
		ObjectMapper om = new ObjectMapper();
		SummonerInfoVO siv = new SummonerInfoVO();
		try {
			// 1. account-v1: Riot ID(gameName#tagLine)로 PUUID 조회
			String gameName = summoner;
			String tagLine = "KR1"; // 기본 태그라인
			if(summoner.contains("#")) {
				String[] parts = summoner.split("#");
				gameName = parts[0];
				tagLine = parts[1];
			}
			String encodedGameName = URLEncoder.encode(gameName, "UTF-8");
			String encodedTagLine = URLEncoder.encode(tagLine, "UTF-8");
			String accountUrl = "https://asia.api.riotgames.com/riot/account/v1/accounts/by-riot-id/"
					+ encodedGameName + "/" + encodedTagLine;
			String accountResponse = rd.getReadData(accountUrl);
			if(accountResponse == null) {
				return null;
			}
			Map<String,Object> accountInfo = om.readValue(accountResponse, Map.class);
			if(accountInfo.get("status") != null) {
				return null;
			}
			String puuid = accountInfo.get("puuid").toString();

			// 2. summoner-v4: PUUID로 소환사 정보 조회 (profileIconId, summonerLevel)
			String summonerUrl = "https://kr.api.riotgames.com/lol/summoner/v4/summoners/by-puuid/" + puuid;
			String summonerResponse = rd.getReadData(summonerUrl);
			if(summonerResponse == null) {
				return null;
			}
			Map<String,Object> summonerInfo = om.readValue(summonerResponse, Map.class);
			if(summonerInfo.get("status") != null) {
				return null;
			}
			// SummonerID 제거됨(2025.07) → PUUID를 기본 식별자로 사용
			siv.setSummonerInfoId(puuid);
			siv.setSummonerInfoAcid(puuid);
			siv.setSummonerInfoName(gameName);
			if((int)summonerInfo.get("profileIconId")<0) {
				siv.setSummonerInfoIcon(0);
			}else {
				siv.setSummonerInfoIcon((int)summonerInfo.get("profileIconId"));
			}
			siv.setSummonerInfoLevel((int)summonerInfo.get("summonerLevel"));

			// 3. league-v4: PUUID로 랭크 정보 조회 (by-summoner 제거됨 → by-puuid 사용)
			String leagueUrl = "https://kr.api.riotgames.com/lol/league/v4/entries/by-puuid/" + puuid;
			String leagueResponse = rd.getReadData(leagueUrl);
			if(leagueResponse == null) {
				return siv;
			}
			List<Map<String,Object>> summonerInfo2 = om.readValue(leagueResponse, List.class);
			if(summonerInfo2.size() == 0) {
				return siv;
			}
			for(Map<String,Object> sum : summonerInfo2) {
				if("RANKED_SOLO_5x5".equals(sum.get("queueType"))) { // 솔로 랭크만 체크
					siv.setSummonerInfoTier(sum.get("tier").toString());
					siv.setSummonerInfoPoint((int)sum.get("leaguePoints"));
					siv.setSummonerInfoLosses((int)sum.get("losses"));
					siv.setSummonerInfoRank(sum.get("rank").toString());
					siv.setSummonerInfoWins((int)sum.get("wins"));
					return siv;
				}
			}

		} catch (JsonProcessingException e) {
			e.printStackTrace();
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return null;
	}

	public List<List<Map<String,Object>>> getGamePage(String userName,int pageNo){
		userName = userName.replace(" ", "");
		SummonerInfoVO summoner = sim.selectSummonerInfo(userName);
		if(summoner == null) {
			return new ArrayList<>();
		}
		int listRange = 10;
		PageVO page = new PageVO();
		page.setListRange(listRange);
		page.setStartRow((pageNo - 1) * listRange);
		summoner.setPage(page);
		List<MatchGameInfoVO> games = mgim.selectMatchGameListById(summoner);
		
		List<List<Map<String,Object>>> gameLists = new ArrayList<>();
		for(MatchGameInfoVO game : games) { //10개씩 게임 데이터 분석
			List<Map<String,Object>> gameList = new ArrayList<>();
			String matchGameId = game.getMatchGameId();
			List<MatchGameInfoVO> matchGame = mgim.selectMatchGameId(matchGameId);
			gameList = matchGameParse(matchGame, summoner.getSummonerInfoId());
			gameLists.add(gameList);
		}
		return gameLists;
	}
	
	
	public void parseGames(String summoner) {
		summoner = summoner.replace(" ", "");
		SummonerInfoVO summonerInfo = sim.selectSummonerInfo(summoner);
		if(summonerInfo==null) {
			log.warn("소환사 정보 없음: {}", summoner);
			return;
		}

		int cnt = mgim.totalMatchGameByName(summoner);
		long timeValue = summonerInfo.getSummonerInfoMod();
		Date date = new Date();
		long today = date.getTime();
		long betweenTime = (long) Math.floor( (today - timeValue) / 1000/ 60);
		if(betweenTime<6 && cnt !=0) {
			log.info("최근 업데이트 {}분 전, 기존 데이터 {}건 → 스킵", betweenTime, cnt);
			return;
		}
		summonerInfo.setSummonerInfoMod(today);
		sim.updateSummonerInfo(summonerInfo);

		String url = "https://asia.api.riotgames.com/lol/match/v5/matches/by-puuid/"
				+ summonerInfo.getSummonerInfoAcid()
				+ "/ids?type=ranked&start=0&count=20";
		try {
			String response = rd.getReadData(url);
			if(response == null) {
				log.error("매치 목록 API 응답 없음");
				return;
			}
			ObjectMapper om = new ObjectMapper();
			List<String> list = om.readValue(response, List.class);
			if(list==null || list.isEmpty()) {
				log.info("매치 목록이 비어있음");
				return;
			}
			log.info("매치 {}건 처리 시작", list.size());
			for(String matchId : list) {
				List<MatchGameInfoVO> matchGame = mim.selectMatchGameId(matchId);
				if(matchGame.size() != 0) {
					continue;
				}
				try {
					log.info("매치 데이터 수집: {}", matchId);
					Thread.sleep(2400);
					pmg.getMatchData(matchId);
				} catch (Exception e) {
					log.error("매치 데이터 수집 실패: {}", matchId, e);
				}
			}
			log.info("매치 처리 완료");
		} catch (Exception e) {
			log.error("parseGames 실패", e);
		}
	}
	
	@Override
	public SummonerInfoVO searchSummonerInfo(String summoner) {
		
		if(summoner == null || summoner.trim() == "") {// 빈문자 or null 값 벨리데이션
			return null;
		}
		summoner = summoner.replace(" ", "");
		Date date = new Date();
		SummonerInfoVO summonerInfo = sim.selectSummonerInfo(summoner);
		long nowTime = date.getTime();
		if(summonerInfo == null) {
			summonerInfo = getSummoner(summoner);
			if(summonerInfo != null) {
				summonerInfo.setSummonerInfoMod(nowTime);
				 sim.insertSummonerInfo(summonerInfo);
				
			}else {
				return null;
			}
		}else {
			long m = summonerInfo.getSummonerInfoMod();
			if(m==0) {
				summonerInfo = getSummoner(summoner);
				summonerInfo.setSummonerInfoMod(nowTime);
				sim.updateSummonerInfo(summonerInfo);
			}
		}
		return sim.selectSummonerInfo(summoner);
	}
}
