<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<script type="text/javascript">
	function validateForm() {
		// Checking to make sure that ISBN and pagenum are numbers
		var isbn = document.forms["add"]["isbn"].value;
		var pagenum = document.forms["add"]["pagenum"].value;
		if (isNaN(isbn)) {
			alert("ISBN needs to be a number.");
			return false;
		}
		if (pagenum !== "") {
			if (isNaN(pagenum)) {
				alert("The number of pages isn't a number.");
				return false;
			} else if (pagenum < 1) {
				alert("Can't have less than 1 page.");
				return false;
			}
		}
	}
</script>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Lib: Add Book</title>
</head>
<body>
	<form name="add" action="addbook" method="post"
		onsubmit="return validateForm()">
		<p>
			ISBN: <input type="text" name="isbn" size="13" maxlength="13"
				required>
		</p>
		<p>
			Title: <input type="text" name="title" size="20" maxlength="50"
				required>
		</p>
		<p>
			Author: <input type="text" name="author" size="20" maxlength="50"
				required>
		</p>
		<p>
			Genre: <select name="genre">
				<option value="ActionandAdventure">Action and Adventure</option>
				<option value="ChickLit">Chick Lit</option>
				<option value="Childrens">Children's</option>
				<option value="CommercialFiction">Commercial Fiction</option>
				<option value="Contemporary">Contemporary</option>
				<option value="Crime">Crime</option>
				<option value="Erotica">Erotica</option>
				<option value="FamilySaga">Family Saga</option>
				<option value="Fantasy">Fantasy</option>
				<option value="DarkFantasy">Dark Fantasy</option>
				<option value="GayandLesbian">Gay and Lesbian</option>
				<option value="GeneralFiction">General Fiction</option>
				<option value="GraphicNovels">Graphic Novels</option>
				<option value="HistoricalFiction">Historical Fiction</option>
				<option value="Horror">Horror</option>
				<option value="Humour">Humour</option>
				<option value="LiteraryFiction">Literary Fiction</option>
				<option value="MilitaryandEspionage">Military and Espionage</option>
				<option value="Multicultural">Multicultural</option>
				<option value="Mystery">Mystery</option>
				<option value="OffbeatorQuirky">Offbeat or Quirky</option>
				<option value="PictureBooks">Picture Books</option>
				<option value="ReligiousandInspirational">Religious and
					Inspirational</option>
				<option value="Romance">Romance</option>
				<option value="ScienceFiction">Science Fiction</option>
				<option value="ShortStoryCollections">Short Story
					Collections</option>
				<option value="ThrillersandSuspense">Thrillers and Suspense</option>
				<option value="Western">Western</option>
				<option value="WomensFiction">Women's Fiction</option>
				<option value="YoungAdult">Young Adult</option>
				<option value="ArtPhotography">Art and Photography</option>
				<option value="BiographyMemoirs">Biography and Memoirs</option>
				<option value="BusinessFinance">Business and Finance</option>
				<option value="CelebrityPopCulture">Celebrity and Pop
					Culture</option>
				<option value="MusicFilmEntertainment">Music Film and
					Entertainment</option>
				<option value="Cookbooks">Cookbooks</option>
				<option value="CulturalSocialIssues">Cultural/Social Issues</option>
				<option value="CurrentAffairsPolitics">Current Affairs and
					Politics</option>
				<option value="FoodLifestyle">Food and Lifestyle</option>
				<option value="Gardening">Gardening</option>
				<option value="GayLesbian">Gay and Lesbian</option>
				<option value="GeneralNonFiction">General Non-Fiction</option>
				<option value="HistoryMilitary">History and Military</option>
				<option value="HomeDecoratingDesign">Home Decorating and
					Design</option>
				<option value="HowTo">How To</option>
				<option value="HumourGiftBooks">Humour and Gift Books</option>
				<option value="Journalism">Journalism</option>
				<option value="Juvenile">Juvenile</option>
				<option value="MedicalHealthFitness">Medical Health and
					Fitness</option>
				<option value="Multicultural">Multicultural</option>
				<option value="Narrative">Narrative</option>
				<option value="NatureEcology">Nature and Ecology</option>
				<option value="Parenting">Parenting</option>
				<option value="Pets">Pets</option>
				<option value="Psychology">Psychology</option>
				<option value="Reference">Reference</option>
				<option value="RelationshipDating">Relationship and Dating</option>
				<option value="ReligionSpirituality">Religion and
					Spirituality</option>
				<option value="ScienceTechnology">Science and Technology</option>
				<option value="SelfHelp">Self-Help</option>
				<option value="Sports">Sports</option>
				<option value="Travel">Travel</option>
				<option value="TrueAdventureTrueCrime">True Adventure and
					True Crime</option>
				<option value="WomensIssues">Women's Issues</option>
				<option value="Other">Other</option>
			</select>
		</p>
		<p>
			Number of Pages: <input type="text" name="pagenum" size="4"
				maxlength="4">
		</p>
		<input type="submit">
	</form>
</body>
</html>